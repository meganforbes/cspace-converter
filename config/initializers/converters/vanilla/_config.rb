module CollectionSpace
  module Converter
    module Vanilla
      def self.config
        @config ||= YAML.safe_load(
          File.open(
            File.expand_path('config.yml', __dir__)
          )
        )
      end

      def self.registered_procedures
        config['registered_procedures']
      end

      def self.registered_profiles
        config['registered_profiles']
      end
    end
  end
end
