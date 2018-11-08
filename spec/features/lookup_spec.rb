require 'rails_helper'

RSpec.describe Lookup do

  describe "can find converter class names" do

    it "returns the authority class" do
      expect(
        Lookup.authority_class('Vanilla', 'Person')
      ).to eq CollectionSpace::Converter::Vanilla::VanillaPerson
    end

    it "returns the converter class" do
      [
        'Authority',
        'Procedure',
        'Relationship'
      ].each do |category|
        expect(
          Lookup.category_class(category)
        ).to eq "CollectionSpace::Converter::#{category}".constantize
      end
    end

    it "returns the converter class" do
      expect(
        Lookup.converter_class('Vanilla')
      ).to eq CollectionSpace::Converter::Vanilla
    end

    it "returns the default authority class" do
      expect(
        Lookup.default_authority_class('Person')
      ).to eq CollectionSpace::Converter::Default::Person
    end

    it "returns the default class" do
      expect(
        Lookup.default_converter_class
      ).to eq CollectionSpace::Converter::Default
    end

    it "returns the default relationship class" do
      expect(
        Lookup.default_relationship_class
      ).to eq CollectionSpace::Converter::Default::Relationship
    end

    it "returns the procedure class" do
      expect(
        Lookup.procedure_class('Vanilla', 'CollectionObject')
      ).to eq CollectionSpace::Converter::Vanilla::VanillaCollectionObject
    end

  end

end
