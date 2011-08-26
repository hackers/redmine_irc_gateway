module RedmineIRCGateway
  module Redmine
    class Issue < API

      class << self

        def all(params = {})
          super(({ :limit => 100, :sort => 'updated_on:desc' }).merge!(params))
        end

        def assigned_me
          all({ :assigned_to_id => :me, :sort => 'updated_on:desc' })
        end

        def watched
          all({ :watcher_id => :me, :sort => 'updated_on:desc' })
        end
      end

      def uri
        "#{Issue.site}issues/#{@attributes[:id]}"
      end

    end
  end
end
