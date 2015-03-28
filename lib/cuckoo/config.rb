module Cuckoo
  class Config

    @@config = {}

    def self.config
      @@config
    end
    
    def self.configure(&block)
      factory = ConfigFactory.new
      factory.instance_eval(&block)
      @@config = factory.attributes
    end
  end

  class ConfigFactory < BasicObject
    def initialize
      @attributes = {}
    end

    attr_reader :attributes

    def method_missing(name, *args, &block)
      @attributes[name] = args[0]
    end
  end

end
