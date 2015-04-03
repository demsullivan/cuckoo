module Cuckoo
  class Config

    @@config = {}
    attr_accessor :plugins
    attr_accessor :plugin_config

    def initialize
      @plugins = {}
    end
    
    def self.config
      @@config
    end
    
    def self.configure(&block)
      @@config = Config.new
      
      factory = ConfigFactory.new(@@config)
      factory.instance_eval(&block)
      
      @@config = factory.config
    end
  end

  class ConfigFactory
    def initialize(config)
      @config = config
    end

    attr_reader :attributes
    attr_reader :config

    def plugin(plugin_name, &block)
      require "cuckoo/#{plugin_name.to_s}"
      class_name = plugin_name.to_s.capitalize
      
      plugin_module       = Cuckoo.const_get(class_name)
      plugin_class        = plugin_module.const_get('Plugin')
      plugin_config_class = plugin_module.const_get('ConfigFactory')

      plugin_config_factory = plugin_config_class.new(plugin_name.to_s)
      yield(plugin_config_factory)

      @config.plugins[plugin_name] = plugin_class.new(plugin_config_factory)
    end
  end

end
