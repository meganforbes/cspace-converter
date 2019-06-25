require 'spec_helper'

describe "CollectionSpace" do

  describe "Authority Cache" do
    let(:vocabulary_items) {
      [
        {
          parts: ['vocabularies', 'languages', 'English'],
          value: "eng",
        },
        {
          parts: ['vocabularies', 'socialmediatype', 'facebook'],
          value: "facebook",
        }
      ]
    }

    it "can add to and retrieve vocabularies from the cache" do
      vocabulary_items.each do |vocab|
        _, vocabulary, display_name = vocab[:parts]
        key = AuthCache.cache_key(vocab[:parts])
        Rails.cache.write(
          key,
          vocab[:value]
        )
        expect(
          AuthCache.vocabulary(vocabulary, display_name)
        ).to eq vocab[:value]
      end
    end
  end
end
