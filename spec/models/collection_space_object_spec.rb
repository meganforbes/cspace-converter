require 'rails_helper'

RSpec.describe CollectionSpaceObject do

  describe "initialization" do
    let(:authority_object) {
      CollectionSpaceObject.create({
        category: 'Authority',
        type: 'Person',
        subtype: 'person',
        identifier: 'Mickey Mouse',
        title: 'Mickey Mouse',
      })
    }

    let(:authority_object_fingerprint) {
      CollectionSpace::Converter::Fingerprint.generate(['Person', 'person', 'Mickey Mouse'])
    }

    let(:procedure_object) {
      CollectionSpaceObject.create({
        category: 'Procedure',
        type: 'Acquisition',
        identifier_field: 'acquisitionReferenceNumber',
        identifier: '123',
      })
    }

    let(:procedure_object_fingerprint) {
      CollectionSpace::Converter::Fingerprint.generate(
        ['Acquisition', 'acquisitionReferenceNumber', '123']
      )
    }

    let(:relationship_object) {
      CollectionSpaceObject.create({
        category: 'Relationship',
        identifier: 'xyz',
        type: 'Relationship',
      })
    }

    let(:relationship_object_fingerprint) { nil }

    it "identifies authority categories correctly" do
      expect(authority_object.is_authority?).to be true
      expect(authority_object.is_procedure?).to be false
      expect(authority_object.is_relationship?).to be false
    end

    it "identifies procedure categories correctly" do
      expect(procedure_object.is_authority?).to be false
      expect(procedure_object.is_procedure?).to be true
      expect(procedure_object.is_relationship?).to be false
    end

    it "identifies relationship categories correctly" do
      expect(relationship_object.is_authority?).to be false
      expect(relationship_object.is_procedure?).to be false
      expect(relationship_object.is_relationship?).to be true
    end

    it "fingerprints authority objects correctly" do
      expect(authority_object.fingerprint).to eq authority_object_fingerprint
    end

    it "fingerprints procedure objects correctly" do
      expect(procedure_object.fingerprint).to eq procedure_object_fingerprint
    end

    it "fingerprints relationship objects correctly" do
      expect(relationship_object.fingerprint).to eq relationship_object_fingerprint
    end

  end

end
