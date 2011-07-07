#!/usr/bin/env ruby
# vim:encoding=UTF-8:

$LOAD_PATH << 'lib'
$LOAD_PATH << '../lib'

$KCODE = 'u' unless defined? ::Encoding

require 'rubygems'
require 'net/irc'
require 'logger'
require 'pathname'
require 'yaml'
require 'pit'

class RedmineIrcGateway < Net::IRC::Server::Session
  def server_name
    self.class.to_s
  end

  def server_version
    '0.0.0'
  end

  def owner_channel
    "##{server_name}"
  end

  def owner_user
    server_name
  end

  def initialize(*args)
    super
    @channels = {}
    @config   = Pathname.new(ENV["HOME"]) + ".rig"
    @pit = Pit.get(server_name)
  end

  # login to server
  def on_user(m)
    super
    @real, *@opts = @real.split(/\s+/)
    @opts ||= []

    init_user(m)
  end

  # logout from server
  def on_disconnected
    p @channels
    @channels.each do |chan, info|
      begin
        info[:observer].kill if info[:observer]
      rescue
      end
    end
  end

  # join to channel
  def on_join(m, names = [])
    channels = m.params.first.split(/,/)
    channels.each do |channel|
      @channels[channel] = { :topic => "" } unless @channels.key?(channel)
      post @prefix, JOIN, channel
      ## Join時にユーザ一覧を返す場合はここに追加する。
      post nil, RPL_NAMREPLY,   @prefix.nick, "=", channel, "@#{@prefix.nick} #{names*' '}".strip
      post nil, RPL_ENDOFNAMES, @prefix.nick, channel, "End of NAMES list"
    end
  end

  def on_privmsg(m)
    channel, message, = m.params
    send_message = store_config(message)

    if !send_message.nil?
      m.params[0] = owner_channel
      m.params[1] = send_message
      on_notice m
    elsif @channels.key?(channel)
      post @prefix.nick, PRIVMSG, channel, message
    end
  end

  def on_notice(m)
    channel, message, = m.params
    if @channels.key?(channel)
      post @prefix.nick, NOTICE, channel, message
    end
  end

  def on_topic(m)
    channel, topic, = m.params
    if @channels.key?(channel)
      post @prefix, TOPIC, channel, topic
      @channels[channel][:topic] = topic
    end
  end

  private
  def init_user(m)
    m.params[0] = owner_channel
    users = ["@#{owner_user}"]
    on_join(m, users)
    
    send_message = store_config
    if !send_message.nil?
      m.params[0] = owner_channel
      m.params[1] = send_message
      on_notice m
    end
  end

  private
  def store_config(message = nil)

    if message.nil?
      "Please, input Redmine Url"
    elsif @pit[:redmine_url].nil?
      save_config(:redmine_url, message)
      "Please, input Redmine User"
    elsif @pit[:redmine_user].nil?
      save_config(:redmine_user, message)
      "Please, input Redmine Password"
    elsif @pit[:redmine_password].nil?
      save_config(:redmine_password, message)
      "Stored Config. Thanks."
    else
      nil
    end

  end

  private
  def save_config(key, value)
    @pit[key] = value
    Pit.set(server_name, :data => @pit)
  end

end

if __FILE__ == $0
  require "optparse"

  opts = {
    :port  => 16700,
    :host  => "localhost",
    :log   => nil,
    :debug => false,
    :foreground => false,
  }

  OptionParser.new do |parser|
    parser.instance_eval do
      self.banner  = <<-EOB.gsub(/^\t+/, "")
        Usage: #{$0} [opts]

      EOB

      separator ""

      separator "Options:"
      on("-p", "--port [PORT=#{opts[:port]}]", "port number to listen") do |port|
        opts[:port] = port
      end

      on("-h", "--host [HOST=#{opts[:host]}]", "host name or IP address to listen") do |host|
        opts[:host] = host
      end

      on("-l", "--log LOG", "log file") do |log|
        opts[:log] = log
      end

      on("--debug", "Enable debug mode") do |debug|
        opts[:log]   = $stdout
        opts[:debug] = true
      end

      on("-f", "--foreground", "run foreground") do |foreground|
        opts[:log]        = $stdout
        opts[:foreground] = true
      end

      parse!(ARGV)
    end
  end

  opts[:logger] = Logger.new(opts[:log], "daily")
  opts[:logger].level = opts[:debug] ? Logger::DEBUG : Logger::INFO

  def daemonize(foreground=false)
    trap("SIGINT")  { exit! 0 }
    trap("SIGTERM") { exit! 0 }
    trap("SIGHUP")  { exit! 0 }
    return yield if $DEBUG || foreground
    Process.fork do
      Process.setsid
      Dir.chdir "/"
      File.open("/dev/null") {|f|
        STDIN.reopen  f
        STDOUT.reopen f
        STDERR.reopen f
      }
      yield
    end
    exit! 0
  end

  daemonize(opts[:debug] || opts[:foreground]) do
    Net::IRC::Server.new(opts[:host], opts[:port], RedmineIrcGateway, opts).start
  end
end
