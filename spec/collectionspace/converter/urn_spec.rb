require 'spec_helper'

describe "CollectionSpace" do

  describe "URN" do
    before(:all) do
      CacheObject.destroy_all
    end

    let(:vocab_urn) {
      "urn:cspace:core.collectionspace.org:vocabularies:name(languages):item:name(english)'English'"
    }

    it "can generate vocabulary urn when not in cache" do
      expect(
        CSURN.get_vocab_urn('languages', 'English')
      ).to eq vocab_urn
    end

    it "can parse type from vocabulary refname" do
      expect(CSURN.parse_type(vocab_urn)).to eq 'vocabularies'
    end

    it "can parse subtype from vocabulary refname" do
      expect(CSURN.parse_subtype(vocab_urn)).to eq 'languages'
    end
  end
end
