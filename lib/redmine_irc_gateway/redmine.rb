module RedmineIRCGateway
  module Redmine
    extend self

    require 'redmine_irc_gateway/redmine/api'
    require 'redmine_irc_gateway/redmine/project'
    require 'redmine_irc_gateway/redmine/issue'
    require 'redmine_irc_gateway/redmine/user'
    require 'redmine_irc_gateway/redmine/time_entry'
    require 'redmine_irc_gateway/redmine/version'

    def build_issue_description issue, updated = false
      speaker = (updated ? issue.updated_by : (issue.assigned_to || issue.author)).name.gsub(' ', '')
      reply_to = if issue.assigned_to and speaker != issue.assigned_to.name.gsub!(' ', '')
                   ' @' + issue.assigned_to.name
                 else
                   nil
                 end

      prefix = ["4#{updated ? '»': '›'}", reply_to].join

      OpenStruct.new({
        :speaker     => speaker,
        :project_id  => issue.project.id,
        :content     => [
                          prefix,
                          "[#{issue.project.name} - #{issue.tracker.name} ##{issue.id}]",
                          "(#{issue.status.name} #{issue.done_ratio}% : #{issue.priority.name})",
                          issue.subject,
                          "14#{issue.uri}"
                         ].join(' ')
      })
    end

  end
end
