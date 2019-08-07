require 'spec_helper'

describe "CollectionSpace" do

  describe "Authority Cache" do
    let(:cache_object_authority) {
      build(
        :cache_object,
      )
    }

    let(:cache_object_vocabulary) {
      build(
        :cache_object,
        refname: "urn:cspace:core.collectionspace.org:vocabularies:name(languages):item:name(eng)'English'",
        name: 'English',
        identifier: 'eng'
      )
    }

    it "can load and retrieve cache objects" do
      cache_object_authority.save
      expect(
        AuthCache.authority('orgauthorities', 'organization', 'Barnes Foundation')
      ).to eq 'BarnesFoundation1542642516661'
    end

    it "can add to and retrieve vocabularies from the cache" do
      cache_object_vocabulary.save
      expect(
        AuthCache.vocabulary('languages', 'English')
      ).to eq 'eng'
    end
  end
end
