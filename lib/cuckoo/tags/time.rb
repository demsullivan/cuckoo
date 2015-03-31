module Cuckoo
  module Taggers
    class Time
      TIME_WORDS     = %w(on at yesterday today)
      DURATION_WORDS = %w(for)
      T_AND_D_WORDS  = %w(last)
      ESTIMATE_WORDS = %w(in)
      TIME_TAGS      = [:time, :duration, :estimate]
      ANCHOR_WORDS   = TIME_WORDS + DURATION_WORDS + ESTIMATE_WORDS + T_AND_D_WORDS
      
      def self.scan(tokens)
        previous = Token.new("")

        tokens.each do |tok|        
          if ANCHOR_WORDS.include? tok.word
            # we don't want to tag "at" as an anchor word if it's already in the context of
            # a timestamp, eg. both "last Friday at 4pm" and "at 4pm" should be valid.
            tok.tag(:anchor) unless tok.word == 'at' and previous.tags.include? :time
          end

          if previous.tags.include? :anchor
            tok = identify_context(tok, previous)
          elsif TIME_TAGS.include? previous.tags.first and !tok.tags.include? :anchor
            tok.tag previous.tags.first
          end

          previous = tok
          
        end
        
      end

      ################################################################################
      private
      ################################################################################
      
      def self.identify_context(tok, previous)
        tok.tag(:time)     if TIME_WORDS.include?     previous.word
        tok.tag(:duration) if DURATION_WORDS.include?(previous.word) and tok.word =~ /^\d+/
        tok.tag(:estimate) if ESTIMATE_WORDS.include?(previous.word) and tok.word =~ /^\d+/

        if T_AND_D_WORDS.include? previous.word
          tok.tag(:time)     if tok.word =~ /^[[:alpha:]]+$/
          tok.tag(:duration) if tok.word =~ /^\d+/
        end

        tok
        
      end

    end
  end
end
