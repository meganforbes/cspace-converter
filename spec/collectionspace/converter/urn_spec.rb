require 'spec_helper'

describe "CollectionSpace" do

  describe "URN" do
    let(:vocab_urn_no_cache) {
      "urn:cspace:core.collectionspace.org:vocabularies:name(languages):item:name(english)'English'"
    }

    let(:vocab_urn_with_cache) {
      "urn:cspace:core.collectionspace.org:vocabularies:name(languages):item:name(eng)'English'"
    }

    it "can generate vocabulary urn when not in cache" do
      expect(
        CSURN.get_vocab_urn('languages', 'English')
      ).to eq vocab_urn_no_cache
    end

    it "can generate vocabulary urn with cache" do
      key = AuthCache.cache_key(['vocabularies', 'languages', 'English'])
      Rails.cache.write(key, 'eng')
      expect(
        CSURN.get_vocab_urn('languages', 'English')
      ).to eq vocab_urn_with_cache
    end
  end
end