module Cuckoo
  class Context
    %w(cmd date project duration estimate task taskid queue timer time_entry).each do |attr|
      attr_accessor attr.to_sym
    end

    def initialize
      @queue = Queue.new
      @tags = []
    end

    def tags=(val)
      if val.is_a? String
        @tags = [val]
      end
    end

    def tags
      @tags
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
      not @taskid.nil? and @taskid.length > 0
    end

    def has_active_task?
      not @task.nil? and not @time_entry.nil?
    end
    
    def merge!(other)
      %w(project tags date duration estimate task taskid).each do |var|
        instance_variable_set("@#{var}".to_sym, other.send(var)) if other.send("has_#{var}?")
      end
    end
    
  end
end
