module RedmineIRCGateway
  module Redmine
    extend self

    def all
      Redmine::Issue.all.reverse.collect { |i| build_issue_description(i) }
    end

    def list
      Redmine::Issue.assigned_me.reverse.collect { |i| build_issue_description(i) }
    end

    def watch
      Redmine::Issue.watched.reverse.collect { |i| build_issue_description(i) }
    end

    def online_users project_id
      Project.find(project_id).issues.collect { |i| i.author.name.gsub(' ', '') }
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
                          "#{issue.uri}"
                         ].join(' ')
      })
    end
  end
end
