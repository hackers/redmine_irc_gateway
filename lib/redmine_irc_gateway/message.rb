module RedmineIRCGateway
  # This class is message object for irc and Redmine issue.
  #
  # == An example
  #
  #     m = Message.new({
  #          :channel    => '#channel',
  #          :project_id => 'Redmine project id',
  #          :content    => 'message body',
  #          :speaker    => 'IRC nick or Redmine user name'
  #        })
  #     puts m.channel # channel name
  class Message < OpenStruct

    def instruction
      content.downcase.to_sym
    end

  end
end
