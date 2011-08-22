module RedmineIRCGateway
  module Command
    extend self

    def list
      issues = []
      Redmine::Issue.assigned_me.each do |i|
        issues << [i.author.name.gsub(' ', ''), "[#{i.project.name}] ##{i.id} #{i.subject} #{i.uri}"]
        #issues << "[#{i.project.name}] ##{i.id} #{i.subject} #{i.uri}"
      end
      issues
    end

    def watch
      issues = []
      Redmine::Issue.watched.each do |i|
        issues << [i.author.name.gsub(' ', ''), "[#{i.project.name}] ##{i.id} #{i.subject} #{i.uri}"]
      end
      issues
    end

  end
end
