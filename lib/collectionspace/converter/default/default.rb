module CollectionSpace
  module Converter
    module Default
      def self.registered_procedures
        []
      end

      def self.registered_profiles
        {}
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
