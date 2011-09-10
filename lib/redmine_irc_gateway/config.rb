require 'yaml'
require 'yaml/store'

module RedmineIRCGateway
  class Config < OpenStruct

    attr_reader :path

    class << self
      def load(name = 'config')
        self.new name
      end
    end

    def initialize name
      @name = name
      @path = user_config || default_config
      super YAML.load_file @path
    end

    def user_config
      get_enable_path "#{File.expand_path('~')}/.rig/#{@name}.yml"
    end

    def default_config
      get_enable_path "#{File.expand_path('../../../config', __FILE__)}/#{@name}.yml"
    end

    def save
      yaml = YAML::Store.new @path
      yaml.transaction do
        self.table.each do |k, v|
          yaml[k] = v
        end
      end
    end

    private

    def get_enable_path path
      path if File.exist? path
    end

  end
end
