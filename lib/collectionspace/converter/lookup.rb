module CollectionSpace
  module Converter
    module Lookup
      ::Lookup = CollectionSpace::Converter::Lookup
      CONVERTER_BASE    = "CollectionSpace::Converter"
      CONVERTER_DEFAULT = "#{CONVERTER_BASE}::Default"
      CONVERTER_MODULE  = ENV.fetch('CSPACE_CONVERTER_MODULE')

      # i.e. #{CONVERTER_BASE}::Core::CoreMaterials
      def self.authority_class(authority)
        "#{CONVERTER_BASE}::#{CONVERTER_MODULE}::#{CONVERTER_MODULE}#{authority}".constantize
      end

      def self.converter_class
        "#{CONVERTER_BASE}::#{CONVERTER_MODULE}".constantize
      end

      def self.default_authority_class(authority)
        "#{CONVERTER_DEFAULT}::#{authority}".constantize
      end

      def self.default_converter_class
        "#{CONVERTER_DEFAULT}".constantize
      end

      def self.default_relationship_class
        "#{CONVERTER_DEFAULT}::Relationship".constantize
      end

      def self.parts_for(category)
        "#{CONVERTER_BASE}::Fingerprint::#{category}".constantize
      end

      # i.e. #{CONVERTER_BASE}::PBM::PBMCollectionObject
      def self.procedure_class(procedure)
        "#{CONVERTER_BASE}::#{CONVERTER_MODULE}::#{CONVERTER_MODULE}#{procedure}".constantize
      end
    end
  end
end
