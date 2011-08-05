require 'logger'
require 'slop'

module RedmineIRCGateway
  class Server
    attr_accessor :opts

    def initialize
      @opts = Slop.parse :help => true do
        banner "Usage: #{$0} [options]"
        on :p, :port,    'Port number to listen',             true,  :as => :integer, :default => 16700
        on :h, :host,    'Host name or IP address to listen', true,  :as => :string,  :default => nil
        on :l, :log,     'log file',                          true,  :as => :string,  :default => nil
        on :d, :debug,   'Enable debug mode',                 false, :as => :boolean, :default => false
        on :v, :version, 'Print the version' do
          puts RedmineIRCGateway::VERSION
          exit
        end
      end.to_hash

      @opts.each { |key, val|
        puts "#{key}: #{val}" if !val.nil?
      }

      @opts[:logger] = Logger.new STDOUT
      @opts[:logger].level = @opts[:debug] ? Logger::DEBUG : Logger::INFO
    end

    def self.run!
      self.new.run!
    end

    def start
      Net::IRC::Server.new(@opts[:host], @opts[:port], RedmineIRCGateway::Session, @opts).start
    end
    alias :run! :start
  end
end
