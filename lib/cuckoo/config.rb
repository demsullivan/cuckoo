module Cuckoo
  class Config
    def self.configure(&block)
      factory = ConfigFactory.new
      factory.instance_eval(&block)
      self.config = factory.attributes
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
