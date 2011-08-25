module RedmineIRCGateway
  module Redmine
    class Issue < API
      class << self

        def all(params = nil)
          if params
            super({ :sort => :updated_on, :order => :asc }.merge(params))
          else
            super
          end
        end

        def assigned_me
          all({:assigned_to_id => :me, :sort => :updated_on, :order => :asc})
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
