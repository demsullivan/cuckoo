require 'chronic'
require 'chronic_duration'
require 'pry'

module Cuckoo
  class CommandInput

    PROJECT_PATTERN   = /@\w+/
    TAGS_PATTERN      = /#[a-zA-Z]+/
    DATE_PATTERNS     = [/last [[:alpha]]+/, /on [[:alpha:]]+/, /at \w+/]
    DURATION_PATTERNS = [/for [a-zA-Z0-9: ]+/, /last \d+/]
    ESTIMATE_PATTERN  = /in [\w+ ]+\?/
    TASK_ID_PATTERN   = /#\d+/

    attr_accessor :context
    attr_accessor :line
    
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
      project_token = @line.scan(PROJECT_PATTERN)
      @context.project = project_token if project_token.length > 0
    end

    def remove_project(line)
      line.gsub(@context.project, "")
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
