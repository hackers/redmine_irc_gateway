module RedmineIRCGateway
  module Redmine
    class Issue < API
      def self.assigned_me
        all({ :params => { :assigned_to_id => :me } })
      end

      def self.watched
        all({ :params => { :watcher_id => :me } })
      end
    end
  end
end
