module RedmineIRCGateway
  module Redmine
    class User < API
      class << self
        def current
          find(:current)
        end
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
