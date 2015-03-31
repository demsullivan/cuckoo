module Cuckoo
  class Completer
    def initialize
      @parser = Parser.new
    end
    
    def call(text)
      @text    = text
      @context = @parser.parse(text)

      subject  = Token.new(@text.split(' ').last)

      [Taggers::Project, Taggers::Tag, Taggers::TaskId].each do |tok|
        tok.scan [subject]
      end

      if subject.tags.include? :project
        complete_project subject.word
      elsif subject.tags.include? :tags
        complete_tags subject.word
      elsif subject.tags.include? :taskid
        complete_task subject.word
      end
    end

    ################################################################################
    private
    ################################################################################
    def complete_project(word)
      ['project', 'project2']
      # Project.where("name LIKE ':project_name%'", {project_name: word}).select("name")
    end

    def complete_tags(word)
      ['tags', 'tags2']
    end

    def complete_task(word)
      ["#{@context.project} task", "#{@context.project} task 2"]
      # Task.where(:project => {:name => @context.project}).where("id_string LIKE ':task_id%'", {task_id: word[1..-1]}).select("id_string", "name")
    end
    
  end  
end
