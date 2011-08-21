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

    end
  end
end
