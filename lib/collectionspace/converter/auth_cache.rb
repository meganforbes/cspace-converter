module CollectionSpace
  module Converter
    module AuthCache
      ::AuthCache = Converter::AuthCache
      # AuthCache::FileLoader.new(file).setup
      class FileLoader
        attr_reader :file, :type
        def initialize(file)
          @file = file
        end

        def parse_keys(object)
          object.each do |k1, v1|
            v1.each do |k2, v2|
              v2.each do |k3, v3|
                parts = [k1, k2, k3]
                value = v3
                yield parts, value
              end
            end
          end
        end

        # FILE CACHE FORMAT
        # "citationauthorities" "citation" "getty aat" => "getty_att"
        # "acquisition" "acquisitionReferenceNumber" "$id" => "$csid"
        # "vocabularies" "socialmediatype" "facebook" => "facebook"
        def setup
          unless File.file? file
            Rails.logger.warn "No authority cache file found at #{file}"
            return
          end
          Rails.logger.debug "The file name is #{file}."
          file_cache = JSON.parse(File.read(file))
          parse_keys(file_cache) do |parts, value|
            Rails.cache.write(AuthCache.cache_key(parts), value)
          end
        end
      end

      # AuthCache::ApiLoader.new(client).setup
      class ApiLoader
      end

      def self.cache_key(parts = [])
        Digest::MD5.hexdigest parts.map(&:downcase).join('.')
      end

      def self.fetch(key)
        Rails.cache.fetch(key)
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
