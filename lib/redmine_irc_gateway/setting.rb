module RedmineIRCGateway
  module Setting

    include Net::IRC::Constants 

    def self.help
      commands = [
        [NOTICE, 'PROJECT  - JOIN PROJECT LIST'],
      ]
    end

    def self.project
      project = []
      Redmine::User.current.projects.each do |p|
        project << [NOTICE, "[#{p.id}] #{p.name}"]
      end
      project
    end

    #def self.channel(channel, project_id)
    #  commands = []
      #if Redmine::User.project?(project_id)
    #    commands << [JOIN, channel, []]
    #    commands << [TOPIC, channel, project_id]
      #end
    #end

  end
end
