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

      tokens  = split_text.map { |word| Token.new(word) }

      [Taggers::Project, Taggers::Tag, Taggers::TaskId].each do |tok|
        tok.scan(tokens)
      end

      subject = tokens.last
      
      if subject.tags.include? :project
        complete_project subject.word
      elsif subject.tags.include? :taskid or subject.word == '#'
        complete_task subject.word
      else
        @before = @text.sub(@context.task, '').rstrip
        complete_task_by_name @context.task
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
      tasks = Task.joins(:project).where(projects: {code: @context.project})
      tasks = tasks.where("external_task_id LIKE :task_id", {task_id: "#{word[1..-1]}%"}).
              select("external_task_id", "name") unless word == '#'
      
      tasks.map { |t| "#{@before} ##{t.external_task_id} #{t.name}" }
    end

    def complete_task_by_name(word)
      tasks = Task.joins(:project).where(projects: {code: @context.project}).
              where("tasks.name LIKE :task_name", {task_name: "#{word}%"})

      tasks.map { |t| "#{@before} #{t.name} ##{t.external_task_id}" }
    end
    
  end  
end
