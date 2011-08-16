module RedmineIRCGateway
  module Redmine
    class Project < API
      def issues
        Issue.all({:project_id => @attributes[:id]})
      end
    end
  end
end
