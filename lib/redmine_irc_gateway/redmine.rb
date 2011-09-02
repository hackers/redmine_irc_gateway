module RedmineIRCGateway
  module Redmine
    include Command
    extend self

    def build_issue_description issue, updated = false
      speaker = (updated ? issue.updated_by : (issue.assigned_to || issue.author)).name.gsub(' ', '')
      reply_to = if issue.assigned_to and speaker != issue.assigned_to.name.gsub!(' ', '')
                   ' @' + issue.assigned_to.name
                 else
                   nil
                 end

      prefix = ["4#{updated ? '»': '›'}", reply_to].join

      OpenStruct.new({
        :speaker     => speaker,
        :project_id  => issue.project.id,
        :content     => [
                          prefix,
                          "[#{issue.project.name} - #{issue.tracker.name} ##{issue.id}]",
                          "(#{issue.status.name} #{issue.done_ratio}% : #{issue.priority.name})",
                          issue.subject,
                          "14#{issue.uri}"
                         ].join(' ')
      })
    end

    register do

      ##
      # Return Redmine all issues, and save to database.
      #
      # db[redmine issue id] = redmine issue datetime at update
      #
      command :all do
        begin
          db = SDBM.open DB_PATH
          issues = []
          most_old_updated_on = db.values.first || Issue.all.reverse.first.updated_on

          Issue.all.reverse.each do |issue|
            key = issue.id
            if db.include? key
              next if db[key] == issue.updated_on

              db[key] = issue.updated_on
              issues << build_issue_description(issue, issue.updated?)
            else
              next if most_old_updated_on > issue.updated_on

              db[key] = issue.updated_on
              issues << build_issue_description(issue, issue.updated?)
            end
          end
          issues
        rescue => e
          puts e
        ensure
          db.close
        end
      end

      command :me do
        Issue.assigned_me.reverse.collect { |i| build_issue_description(i) }
      end

      command :watch do
        Issue.watched.reverse.collect { |i| build_issue_description(i) }
      end

    end

  end
end
