require 'rails_helper'

RSpec.describe Lookup do

  describe "can find converter class names" do

    it "returns the authority class" do
      expect(
        Lookup.authority_class('Person')
      ).to eq CollectionSpace::Converter::Core::CorePerson
    end

    it "returns the converter class" do
      expect(
        Lookup.converter_class
      ).to eq CollectionSpace::Converter::Core
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

    it "returns the parts classes" do
      ["Authority", "Procedure", "Relationship"].each do |type|
        expect(
          Lookup.parts_for(type)
        ).to eq "CollectionSpace::Converter::Fingerprint::#{type}".constantize
      end
    end

    it "returns the procedure class" do
      expect(
        Lookup.procedure_class('CollectionObject')
      ).to eq CollectionSpace::Converter::Core::CoreCollectionObject
    end

  end

end
