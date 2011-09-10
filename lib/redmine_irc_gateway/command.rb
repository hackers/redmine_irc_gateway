# encoding: utf-8

module RedmineIRCGateway
  module Command
    extend self

    @commands = {}

    def register &block
      module_eval &block if block_given?
    end

    def command(instruction, &block)
      if block_given?
        @commands[instruction.to_sym] = block
      else
        raise SyntaxError, 'No block given'
      end
    end

    def exec instruction
      unless @commands[instruction.to_sym]
        raise NoMethodError, 'Command not found'
      end
      cmd = @commands[instruction.to_sym].call
      raise NoMethodError, 'Not found' if cmd.empty?
      cmd
    rescue => e
      [Message.new({ :content => e.to_s })]
    end

    def help
      @commands.keys.collect { |c| Message.new({ :content => c.to_s }) }
    end

    def method_missing name
      exec name
    end

  end

  Command.register do
    extend Redmine

    ##
    # Return Redmine recent issues, and save to database.
    #
    # db[redmine issue id] = redmine issue datetime at update
    #
    command :recent do
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
