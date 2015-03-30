module Cuckoo
  class Context
    %w(tags date duration estimate task taskid).each do |attr|
      attr_accessor attr.to_sym
    end
    
    def project
      @project
    end
    
    def project=(value)
      unless value.is_a? String or value.length == 1
        raise "You can only specify one project."
      end

      value = value.first if value.is_a? Array
      @project = value
    end

    def has_project?
      not @project.nil?
    end

    def has_tags?
      not @tags.nil? and @tags.length > 0
    end

    def has_date?
      not @date.nil?
    end

    def has_duration?
      not @duration.nil?
    end

    def has_estimate?
      not @estimate.nil?
    end

    def has_task?
      not @task.nil?
    end

    def has_taskid?
      not @taskid.nil?
    end
    
    def merge!(other)
      %w(project tags date duration estimate task taskid).each do |var|
        instance_variable_set("@#{var}".to_sym, other.send(var.to_sym)) if other.send("has_#{var}?".to_sym)
      end
    end
    
  end
end
