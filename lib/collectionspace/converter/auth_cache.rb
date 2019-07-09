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

        # FILE CACHE FORMAT
        # "citationauthorities" "citation" "getty aat" => "getty_att"
        # "acquisition" "acquisitionReferenceNumber" "$id" => "$csid"
        # "vocabularies" "socialmediatype" "facebook" => "facebook"
        def setup
          unless File.file? file
            Rails.logger.warn "No authority cache file found at #{file}"
            return
          end
          SmarterCSV.process(file, {
            chunk_size: 100
          }) do |chunk|
            chunk.each do |item|
              name    = item.key?(:displayname) ? item[:displayname] : item[:termdisplayname]
              subtype = CSURN.parse_subtype item[:refname]
              type    = CSURN.parse_type item[:refname]
              parts   = [type, subtype, name].map(&:to_s)
              value   = item[:shortidentifier]
              Rails.logger.debug "Cached: #{item[:refname]}"
              Rails.cache.write(AuthCache.cache_key(parts), value)
            end
          end
        end
      end

      def self.auth_cache_path(domain)
        Rails.root.join('data', 'auth_cache', domain)
      end

      def self.auth_cache_authorities_file(domain = ENV.fetch('CSPACE_CONVERTER_DOMAIN'))
        Rails.root.join(auth_cache_path(domain), 'authorities.csv')
      end

      def self.auth_cache_vocabularies_file(domain = ENV.fetch('CSPACE_CONVERTER_DOMAIN'))
        Rails.root.join(auth_cache_path(domain), 'vocabularies.csv')
      end

      def self.cache_key(parts = [])
        Digest::MD5.hexdigest parts.compact.map(&:downcase).join('.')
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
