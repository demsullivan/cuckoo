module Cuckoo
  class Context
    def initialize
      @attrs = {}
    end

    %w(project tags date duration estimate line task).each do |method|
      define_method(method) do
        @attrs[method.to_sym]
      end
    end

    %w(tags= date= duration= estimate= line= task=).each do |method|
      define_method(method) do |value|
        @attrs[method.to_sym] = value
      end
    end
    
    def project=(value)
      unless value.is_a? String or value.length == 1
        raise "You can only specify one project."
      end

      value = value[0] if value.is_a? Array
      @attrs[:project] = value
    end

  end
end
