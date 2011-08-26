module RedmineIRCGateway
  module Redmine
    extend self

    def all
      Issue.all.reverse.collect { |i| build_issue_description(i) }
    end

    def list
      Issue.assigned_me.reverse.collect { |i| build_issue_description(i) }
    end

    def watch
      Issue.watched.reverse.collect { |i| build_issue_description(i) }
    end

    def online_users project_id
      issues = Project.find(project_id).issues
      issues.collect { |i| i.author.name.gsub(' ', '') }.uniq if issues
    end

    def build_issue_description issue
      OpenStruct.new({
        :author       => issue.author.name.gsub(' ', ''),
        :project_id   => issue.project.id,
        :project_name => "4#{issue.project.name} ",
        :content      => [
                          "2#{issue.tracker.name}",
                          "3#{issue.status.name}",
                          "#{issue.subject}",
                          "14(#{issue.done_ratio}%)",
                          "15#{issue.uri}"
                         ].join(' ')
      })
    end
  end
end
