module Cuckoo
  class Completer
    
    include Models
    
    def initialize
      @parser = Parser.new
    end
    
    def call(text)
      @text    = text
      @context = @parser.parse(text)

      split_text = @text.split(' ')

      if split_text.length >= 2
        @before  = @text.split(' ')[0..-2].join(' ')
      else
        @before = @text
      end
      
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
      # ['project', 'project2']
      projects = Project.where("code LIKE :project_name", {project_name: "#{word}%"}).select("code")
      projects.map { |p| p.code }
    end

    def complete_tags(word)
      ['tags', 'tags2']
    end

    def complete_task(word)
      # ["#{@context.project} task", "#{@context.project} task 2"]
      tasks = Task.joins(:project).where(projects: {code: @context.project}).where("external_task_id LIKE :task_id", {task_id: "#{word[1..-1]}%"}).select("external_task_id", "name")
      tasks.map { |t| "#{@before} #{word}#{t.external_task_id[word.length..-1]} #{t.name}" }
    end
    
  end  
end
