module RedmineIRCGateway
  module Redmine
    class TimeEntry < API

      class << self

        def recent_me
          all.select { |t| t.user == User.current }
        end

      end

      def issue
        Issue.find(super.id)
      rescue
        nil
      end

    end
  end
end
