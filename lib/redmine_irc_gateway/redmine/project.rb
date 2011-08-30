module RedmineIRCGateway
  module Redmine
    class Project < API

      def issues
        Issue.all({:project_id => @attributes[:id]})
      end

      def member? user
        user.projects.each do |p|
          return true if @attributes[:id] == p.id
        end
        false
      end

      def members
        return unless issues

        users = []
        issues.each do |i|
          users << i.author.name.gsub(' ', '')
          users << i.assigned_to.name.gsub(' ', '') if i.assigned_to
        end
        users.uniq
      end

    end
  end
end
