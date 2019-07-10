require 'rails_helper'

RSpec.describe CacheObject do
  let(:cache_object) {
    build(
      :cache_object,
    )
  }

  it "can generate a cache object" do
    expect(cache_object).to be_valid
    expect(cache_object.type).to eq 'orgauthorities'
    expect(cache_object.subtype).to eq 'organization'
    expect(cache_object.key).to eq AuthCache.cache_key(
      [cache_object.type, cache_object.subtype, cache_object.name]
    )
  end
end
