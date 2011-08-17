require 'yaml'

module RedmineIRCGateway
  class Config < OpenStruct
    class << self
      def load(name)
        self.new YAML.load_file("#{File.expand_path('../../../config', __FILE__)}/#{name}.yml")
      end
    end
  end
end
