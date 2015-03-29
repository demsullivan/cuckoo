module Cuckoo
  class Context
    def initialize
      @attrs = {
        :project  => "",
        :tags     => [],
        :date     => nil,
        :duration => nil,
        :estimate => nil,
        :line     => "",
        :task     => "",
        :taskid   => ""
      }
      
    end

    %w(project tags date duration estimate line task taskid).each do |method|
      define_method(method) do
        @attrs[method.to_sym]
      end
    end

    %w(tags= date= duration= estimate= line= task= taskid=).each do |method|
      define_method(method) do |value|
        @attrs[method.chomp('=').to_sym] = value
      end
    end
    
    def project=(value)
      unless value.is_a? String or value.length == 1
        raise "You can only specify one project."
      end

      value = value.first if value.is_a? Array
      @attrs[:project] = value
    end

  end
end
