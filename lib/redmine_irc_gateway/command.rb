module RedmineIRCGateway
  module Command
    extend self

    def list
      Redmine::Issue.assigned_me
    end

  end
end
