module RedmineIRCGateway
  module Redmine
    class Project < API

      def issues
        Issue.all({ :project_id => @attributes[:id] })
      end

      def member? user
        user.projects.one? { |p| @attributes[:id] == p.id }
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
