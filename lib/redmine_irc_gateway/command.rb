module RedmineIRCGateway
  module Command
    extend self

    attr_reader :names
    @commands = {}

    def register &block
      self.instance_eval &block if block_given?
    end

    def command(instruction, &block)
      if block_given?
        @commands[instruction.to_sym] = block
        @names = @commands.keys
      else
        raise SyntaxError 'No block given'
      end
    end

    def exec instruction
      @commands[instruction.to_sym].call
    end

    def help
      @names.join ' '
    end

    def method_missing name
      exec name
    end

  end

  Command.register do
    extend Redmine

    ##
    # Return Redmine all issues, and save to database.
    #
    # db[redmine issue id] = redmine issue datetime at update
    #
    command :all do
      begin
        db = SDBM.open DB_PATH
        issues = []
        most_old_updated_on = db.values.first || Redmine::Issue.all.reverse.first.updated_on

        Redmine::Issue.all.reverse.each do |issue|
          next if most_old_updated_on > issue.updated_on

          key = issue.id
          next if db.include? key and db[key] == issue.updated_on

          issues << build_issue_description(issue, issue.updated?)
          db[key] = issue.updated_on
        end
        issues
      rescue => e
        puts e
      ensure
        db.close
      end
    end

    command :me do
      Redmine::Issue.assigned_me.reverse.collect { |i| build_issue_description(i) }
    end

    command :watch do
      Redmine::Issue.watched.reverse.collect { |i| build_issue_description(i) }
    end

    command :reported do
      Redmine::Issue.reported.reverse.collect { |i| build_issue_description(i) }
    end

  end
end
