require "chronic"
require "chronic_duration"

module Cuckoo
  
  class Parser
    
    include Taggers
    
    def parse(text)
      context = Cuckoo::Context.new
      tokens = tokenize(text)

      [:project, :tags, :taskid].each do |tag|
        tokens = identify_and_remove_simple_tags(tag, tokens, context)
      end

      tokens = identify_and_remove_time(tokens, context)
      tokens = identify_and_remove_task(tokens, context)
      context
    end

    ################################################################################
    private
    ################################################################################
    def tokenize(text)
      tokens = text.split(' ').map { |word| Token.new(word) }
      [Project, Tag, TaskId, Time].each do |tok|
        tok.scan(tokens)
      end
      tokens
    end

    def identify_and_remove_simple_tags(tag, tokens, context)
      matches = tokens.select { |t| t.tags.include? tag }
      context.send "#{tag.to_s}=".to_sym, matches.map {|t| t.word} if matches.length > 1
      context.send "#{tag.to_s}=".to_sym, matches.first.word       if matches.length == 1
      context.send "#{tag.to_s}=".to_sym, nil                      if matches.length == 0
      tokens - matches
    end

    def tokens_to_string(tokens)
      tokens.map {|t| t.word}.join(" ")
    end
    
    def identify_and_remove_time(tokens, context)
      phrases = {:time => [], :duration => [], :estimate => []}
      current_phrase = []
      previous = Token.new("")

      tokens.each do |tok|
        if tok.tags.include? :anchor
          if previous.tagged? and !current_phrase.empty?
            phrases[previous.tags.first] << current_phrase
            current_phrase = []
          end
        end
        
        if tok.tagged? and (tok.tags.include? previous.tags.first or previous.tags.include? :anchor)
          current_phrase << previous if previous.tags.include? :anchor and ["yesterday", "today"].include? previous.word
          current_phrase << tok
        end
        previous = tok
      end

      phrases[previous.tags.first] << current_phrase unless current_phrase.empty?

      time_matches = []
      phrases[:time].each do |phrase|
        result = Chronic.parse(tokens_to_string(phrase), :context => :past)
        phrase.map {|tok| tok.untag } if result.nil?
        time_matches << result unless result.nil?
      end

      duration_matches = []
      phrases[:duration].each do |phrase|
        result = ChronicDuration.parse(tokens_to_string(phrase))
        phrase.map {|tok| tok.untag } if result.nil?
        duration_matches << result unless result.nil?
      end

      estimate_matches = []
      phrases[:estimate].each do |phrase|
        result = ChronicDuration.parse(tokens_to_string(phrase))
        phrase.map {|tok| tok.untag } if result.nil?
        estimate_matches << result unless result.nil?
      end

      context.date     = time_matches.first
      context.duration = duration_matches.first
      context.estimate = estimate_matches.first
      
      matches = tokens.select {|t| t.tags.include?(:time) or t.tags.include?(:duration) or t.tags.include?(:estimate) or t.tags.include?(:anchor) }
      tokens - matches
    end

    def identify_and_remove_task(tokens, context)
      context.task = tokens_to_string(tokens)
      []
    end
  end
end
