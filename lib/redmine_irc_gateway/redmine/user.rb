module RedmineIRCGateway
  module Redmine
    class User < API
      def self.current
        find(:current)
      end

      def name
        "#{@attributes[:lastname]} #{@attributes[:firstname]}"
      end

      def projects
        projects = []
        User.find(@attributes[:id], {:params => {:include => :memberships}}).memberships.each do |m|
          projects << Project.find(m.project.id)
        end
        projects
      end
    end
  end
end
