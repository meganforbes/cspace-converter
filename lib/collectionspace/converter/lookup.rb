module CollectionSpace
  module Converter
    module Lookup
      ::Lookup = CollectionSpace::Converter::Lookup
      CONVERTER_BASE    = "CollectionSpace::Converter"
      CONVERTER_DEFAULT = "#{CONVERTER_BASE}::Default"
      # i.e. #{CONVERTER_BASE}::Vanilla::VanillaMaterials
      def self.authority_class(converter_module, authority)
        "#{CONVERTER_BASE}::#{converter_module}::#{converter_module}#{authority}".constantize
      end

      def self.category_class(category)
        "#{CONVERTER_BASE}::#{category}".constantize
      end

      def self.converter_class(converter_module)
        "#{CONVERTER_BASE}::#{converter_module}".constantize
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

      # i.e. #{CONVERTER_BASE}::PBM::PBMCollectionObject
      def self.procedure_class(converter_module, procedure)
        "#{CONVERTER_BASE}::#{converter_module}::#{converter_module}#{procedure}".constantize
      end
    end
  end
end
