module RedmineIRCGateway
  module Order
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

    def build_issue_description issue
      [
        issue.author.name.gsub(' ', ''),
        "[#{issue.project.name}] ##{issue.id} #{issue.subject} #{issue.uri}"
      ]
    end
  end
end
