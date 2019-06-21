require 'rails_helper'

RSpec.describe CollectionSpaceObject do

  describe "initialization" do
    let(:authority_object) {
      build(
        :collection_space_object,
        category: 'Authority',
        type: 'Person',
        subtype: 'person',
        identifier: 'Mickey Mouse',
        title: 'Mickey Mouse',
      )
    }

    let(:authority_object_fingerprint) {
      Fingerprint.generate(['Person', 'person', 'Mickey Mouse'])
    }

    let(:procedure_object) {
      build(
        :collection_space_object,
        category: 'Procedure',
        type: 'Acquisition',
        identifier_field: 'acquisitionReferenceNumber',
        identifier: '123',
      )
    }

    let(:procedure_object_fingerprint) {
      Fingerprint.generate(
        ['Acquisition', 'acquisitionReferenceNumber', '123']
      )
    }

    let(:relationship_object) {
      build(
        :collection_space_object,
        category: 'Relationship',
        csid: 'fake',
        identifier: 'xyz',
        type: 'Relationship',
        uri: '/fake',
      )
    }

    let(:relationship_object_fingerprint) { nil }

    it "returns false correctly for no csid and uri check" do
      expect(authority_object.has_csid_and_uri?).to be false
    end

    it "returns true correctly for no csid and uri check" do
      expect(relationship_object.has_csid_and_uri?).to be true
    end

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
      authority_object.set_fingerprint
      expect(authority_object.fingerprint).to eq authority_object_fingerprint
    end

    it "fingerprints procedure objects correctly" do
      procedure_object.set_fingerprint
      expect(procedure_object.fingerprint).to eq procedure_object_fingerprint
    end

    it "fingerprints relationship objects correctly" do
      relationship_object.set_fingerprint
      expect(relationship_object.fingerprint).to eq relationship_object_fingerprint
    end

  end

end
