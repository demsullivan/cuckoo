require 'chronic'
require 'chronic_duration'
require 'pry'
require 'tokenizer'

module Cuckoo

  DATE_PATTERNS     = [/last [[:alpha:]]+/, /on [[:alpha:]]+/, /at \w+/]
  DURATION_PATTERNS = [/for [a-zA-Z0-9: ]+/, /last \d+/]

  
  class PrefixedWord
    def self.scan(text)
      @tokens = text.scan(/#{self.prefix}#{self.pattern}/)
      return @tokens if @tokens.length > 0
    end
  end
  
  class Project < PrefixedWord
    prefix = '@'
    pattern = '\w+'
    tag = 'project'
  end

  class Tag < PrefixedWord
    prefix = '#'
    pattern = '[a-zA-Z]+'
  end

  class TaskId < PrefixedWord
    prefix = '#'
    pattern = '\d+'
  end

  class Estimate < PrefixedWord
    prefix = 'in '
    pattern = '[\w+ ]+\?'
  end

  class DateAndDuration
    def self.find_date_index(text)
      index = nil

      DATE_PATTERNS.each do |pattern|
        index = text.rindex(pattern)
        break unless index.nil?
      end

      index
    end

    def self.find_duration_index(text)
      index = nil

      DURATION_PATTERNS.each do |pattern|
        index = text.rindex(pattern)
        break unless index.nil?
      end

      index
    end
  end
  
  class Date < DateAndDuration
    def self.scan(text)
      date_index     = self.find_date_index
      duration_index = self.find_duration_index

      return if date_index.nil?

      unless duration_index.nil? or duration_index < date_index
        date_token = text[date_index..duration_index-1]
      else
        date_token = text[date_index..-1]
      end
      
      date_token
    end
  end

  class Duration < DateAndDuration
    def self.scan(text)
      date_index     = self.find_date_index
      duration_index = self.find_duration_index
      
      return if duration_index.nil?
      
      unless date_index.nil? or date_index < duration_index
        duration_token = text[duration_index..date_index-1]
      else
        duration_token = text[date_index..-1]
      end
      
      duration_token
    end
  end

  
  class CommandInput

    attr_accessor :context
    attr_accessor :line
    attr_accessor :tokens
    
    def initialize(line, context)
      @line    = line
      @context = context
      process!
    end

    def process!
      identify_project
      identify_tags
      identify_date
      identify_duration
      identify_estimate
      identify_task
    end

    def execute!
      p @line
    end

    ################################################################################
    private
    ################################################################################

    def identify_project
      project_tokens = Project.scan(@line)
      @context.project = project_tokens unless project_tokens.nil?
    end
      
    def identify_tags
      tag_tokens = @line.scan(TAGS_PATTERN)
      @context.tags = tag_tokens if tag_tokens.length > 0
    end

    def remove_tags(line)
      @context.tags.each do |tag|
        line.gsub!(tag, "")
      end
      
      line
    end

    def date_index
      index = nil
      
      DATE_PATTERNS.each do |pattern|
        index = @line.rindex(pattern)
        break unless index.nil?
      end

      index
    end
    
    def identify_date
      index = date_index
      return if index.nil?

      date_token = @line[index..-1]
      
      
      @context.date = Chronic.parse(date_token)
    end

    def remove_date(line)
      index = date_index
      line[0..index-1] unless index.nil?
      line
    end

    def duration_index
      index = nil
      
      DURATION_PATTERNS.each do |pattern|
        index = @line.rindex(pattern)
        break unless index.nil?
      end

      index
    end
    
    def identify_duration
      index = duration_index

      return if index.nil?
      
      duration_token = @line[index..-1]
      @context.duration = ChronicDuration.parse(duration_token)
    end

    def identify_estimate
      match = ESTIMATE_PATTERN.match(@line)
      
      return if match.nil?
      
      @context.estimate = ChronicDuration.parse(match.chomp("?"))
    end

    def identify_task
      line = remove_project(@line)
      line = remove_tags(line)
      line = remove_date(line)
      @context.task = line
    end
    
  end

  class Completer
    def call(line)
      context = Context.new
      command = CommandInput(line, context)
      line.split
    end
  end
end
