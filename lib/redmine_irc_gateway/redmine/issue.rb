module RedmineIRCGateway
  module Redmine
    class Issue < API
      class << self
        def assigned_me
          all({:assigned_to_id => :me})
        end

        def watched
          all({:watcher_id => :me})
        end
      end

      def uri
        "#{Issue.site}/issues/#{@attributes[:id]}"
      end
    end
  end
end
