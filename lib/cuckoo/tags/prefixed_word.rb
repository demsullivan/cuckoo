module Cuckoo
  module Taggers
    class PrefixedWord
      def self.scan(tokens)
        pattern = /^#{self::PREFIX}#{self::PATTERN}$/
        tokens.each { |tok| tok.tag(self::TAG) if tok.word =~ pattern }
      end
    end
  end
end
