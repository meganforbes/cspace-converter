module CollectionSpace
  module Converter
    module AuthCache
      ::AuthCache = Converter::AuthCache
      # CACHE FORMAT
      # "citationauthorities" "citation" "getty aat" => "getty_att"
      # "acquisition" "acquisitionReferenceNumber" "$id" => "$csid"
      # "vocabularies" "socialmediatype" "facebook" => "facebook"

      def self.cache_key(parts = [])
        Digest::MD5.hexdigest parts.compact.map(&:downcase).join('.')
      end

      def self.fetch(key)
        object = CacheObject.where(key: key).first
        object.nil? ? nil : object.identifier
      end

      # public accessor to cached authority terms
      def self.authority(authority, authority_subtype, display_name)
        fetch(cache_key([authority, authority_subtype, display_name]))
      end

      # public accessor to cached vocabulary terms
      def self.vocabulary(vocabulary, display_name)
        fetch(cache_key(['vocabularies', vocabulary, display_name]))
      end

    end
  end
end
