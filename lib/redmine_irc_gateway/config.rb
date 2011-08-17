require 'yaml'
require 'yaml/store'

module RedmineIRCGateway
  class Config < OpenStruct
    def initialize(name)
      @name = name
      @path = "#{File.expand_path('../../../config', __FILE__)}/#{@name}.yml"
      super YAML.load_file(@path)
    end

    def save
      yaml = YAML::Store.new(@path)
      yaml.transaction do
        self.table.each do |k, v|
          yaml[k] = v
        end
      end
    end

    class << self
      def load(name)
        self.new name
      end
    end
  end
end
