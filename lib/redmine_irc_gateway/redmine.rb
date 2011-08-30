module RedmineIRCGateway
  module Redmine
    extend self

    ##
    # Return Redmine all issues, and save to database.
    #
    # db[redmine issue id] = redmine issue datetime at update
    #
    def all
      db = SDBM.open DB_PATH
      issues = []
      most_old_updated_on = db.values.first || Issue.all.reverse.first.updated_on

      Issue.all.reverse.each do |issue|
        key = issue.id
        if db.include? key
          next if db[key] == issue.updated_on

          db[key] = issue.updated_on
          issues << build_issue_description(issue, :update)
        else
          next if most_old_updated_on > issue.updated_on

          db[key] = issue.updated_on
          if issue.created_on == issue.updated_on
            issues << build_issue_description(issue)
          else
            issues << build_issue_description(issue, :update)
          end
        end
      end
      issues
    rescue => e
      puts e
    ensure
      db.close
    end

    def me
      Issue.assigned_me.reverse.collect { |i| build_issue_description(i) }
    end

    def watch
      Issue.watched.reverse.collect { |i| build_issue_description(i) }
    end

    def build_issue_description issue, updated = false
      if updated
        user = issue.updated_by
      else
        user = issue.assigned_to || issue.author
      end

      OpenStruct.new({
        :user         => user.name.gsub(' ', ''),
        :project_id   => issue.project.id,
        :project_name => issue.project.name,
        :content      => [
                          issue.assigned_to ? '@' + issue.assigned_to.name.gsub(' ', '') : nil,
                          updated ? "4Up!" : nil,
                          "##{issue.id}",
                          issue.tracker.name,
                          issue.status.name,
                          issue.priority.name,
                          "『#{issue.subject}』",
                          "14(#{issue.done_ratio}%)",
                          "#{issue.uri}"
                         ].join(' ')
      })
    end

  end
end
