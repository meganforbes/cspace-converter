module CollectionSpace
  module Converter
    module Default
      def self.config
        @config ||= YAML.safe_load(
          File.open(
            File.expand_path('config.yml', __dir__)
          )
        )
      end

      def self.registered_authorities
        config['registered_authorities']
      end

      def self.registered_procedures
        config['registered_procedures']
      end

      def self.registered_profiles
        config['registered_profiles']
      end

      def self.validate_authority!(authority)
        unless [ "Concept", "Location", "Material", "Materials", "Person", "Place", "Organization", "Taxon", "Work" ].include? authority
          raise "Invalid authority #{authority}"
        end
      end

      # set which procedures can be created from model
      def self.validate_procedure!(procedure, converter)
        valid_procedures = converter.registered_procedures
        unless valid_procedures.include?("all") or valid_procedures.include?(procedure)
          raise "Invalid procedure #{procedure}, not permitted by configuration."
        end
      end
    end
  end
end
