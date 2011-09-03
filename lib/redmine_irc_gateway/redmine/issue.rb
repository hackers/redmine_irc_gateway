module RedmineIRCGateway
  module Redmine
    class Issue < API

      class << self

        def all(params = {})
          super({ :sort => 'updated_on:desc' }.merge params)
        end

        def assigned_me
          all({ :assigned_to_id => :me })
        end

        def watched
          all({ :watcher_id => :me })
        end

        def reported
          all({ :author_id => :me })
        end

      end

      def uri
        "#{Issue.site}issues/#{self.id}"
      end

      # Return assigned_to user object
      def assigned_to
        @attributes[:assigned_to]
      end

      # Update assigned to user object
      def assigned_to= user
        id = user ? user.id : nil
        self.assigned_to_id = id
        save
      end

      # Update assigned to me
      def assigned_to_me
        self.assigned_to_id = User.current.id
        save
      end

      # Return issue journals
      def journals
        Issue.find(self.id, { :params => { :include => :journals } }).attributes[:journals]
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

      # Return updated
      def updated?
        self.updated_on > self.created_on
      end

    end
  end
end
