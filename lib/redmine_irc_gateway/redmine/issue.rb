module RedmineIRCGateway
  module Redmine
    class Issue < API

      class << self

        def all(params = {})
          super({ :sort => 'updated_on:desc' }.merge params)
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

      # Return assigned_to user object
      def assigned_to
        @attributes[:assigned_to]
      end

      # Return issue journals
      def journals
        Issue.find(@attributes[:id], { :params => { :include => :journals } }).attributes[:journals]
      end

      # Return latest update user object, but return author user object if not exist update user
      def updated_by
        updates = journals
        if updates.empty?
          author
        else
          updates.first.user
        end
      end

    end
  end
end
