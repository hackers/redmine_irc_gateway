module RedmineIRCGateway
  module Command
    extend self

    def all
      Redmine::Issue.all.collect { |i| build_issue_description(i) }
    end

    def list
      Redmine::Issue.assigned_me.collect { |i| build_issue_description(i) }
    end

    def watch
      Redmine::Issue.watched.collect { |i| build_issue_description(i) }
    end

    def build_issue_description issue
      [
        issue.author.name.gsub(' ', ''),
        "[#{issue.project.name}] ##{issue.id} #{issue.subject} #{issue.uri}"
      ]
    end
  end
end
