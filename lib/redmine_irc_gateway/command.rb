module RedmineIRCGateway
  module Command
    extend self

    def list
      issues = []
      Redmine::Issue.assigned_me.each do |i|
        issues << "[#{i.project.name}] ##{i.id} #{i.subject}"
      end
      issues
    end

  end
end
