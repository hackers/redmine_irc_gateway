# encoding: utf-8

module RedmineIRCGateway
  module Command

    class NotFoundError < StandardError; end

    extend self

    @commands = {}

    def register &block
      module_eval &block if block_given?
    end

    def command(command, &block)
      if block_given?
        @commands[command.to_sym] = block
      else
        raise SyntaxError, 'No block given'
      end
    end

    def exec(command, id)
      unless @commands[command.to_sym]
        raise NotImplementedError, 'Command not found'
      end

      result = @commands[command.to_sym].call(id)

      if result.empty?
        raise NotFoundError, 'Not found'
      end

      result
    rescue Exception => e
      [Message.new({ :content => e.to_s })]
    end

    def commands
      @commands.keys.collect { |c| Message.new({ :content => c.to_s }) }
    end

    def method_missing(command, *arguments)
      @commands[command.to_sym].call(*arguments)
    rescue => e
      [Message.new({ :content => e.to_s })]
    end

    def build_issue_uri issue
      Message.new({
        :speaker     => issue.author.name.gsub(' ', ''),
        :project_id  => issue.project.id,
        :content     => issue.uri
      })
    end

    def build_issue_description(issue, updated = false)
      speaker = (updated ? issue.updated_by : (issue.assigned_to || issue.author)).name.gsub(' ', '')
      reply_to = if issue.assigned_to and speaker != issue.assigned_to.name.gsub!(' ', '')
                   ' @' + issue.assigned_to.name
                 else
                   nil
                 end

      prefix = ["4#{updated ? '»': '›'}", reply_to].join

      Message.new({
        :speaker     => speaker,
        :project_id  => issue.project.id,
        :content     => [
                          prefix,
                          "[#{issue.project.name} - #{issue.tracker.name}]",
                          "(#{issue.status.name} #{issue.done_ratio}% : #{issue.priority.name})",
                          issue.subject,
                          "14(##{issue.id})"
                         ].join(' ')
      })
    end

  end

  Command.register do
    extend Redmine

    #
    # Return Redmine recent issues, and save to database.
    #
    # db[redmine issue id] = redmine issue datetime at update
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

    command :link do |id|
      [build_issue_uri(Redmine::Issue.find(id))]
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

    command :project do
      Redmine::User.current.projects.collect do |p|
        Message.new({ :content => "[#{p.id}] #{p.name}" })
      end
    end

    command :time do
      Redmine::TimeEntry.recent_me.collect do |t|
        issue = t.send(:issue) ? "(##{t.issue.id}) #{t.issue.subject}" : nil
        Message.new(
          { :content => "#{t.project.name} #{issue} #{t.activity.name} #{t.comments} #{t.hours}H" }
        )
      end
    end

    command :help do
      Command.commands.collect do |c|
        Message.new({ :content => c.content })
      end
    end

  end
end
