module CollectionSpace
    module AuthCache
      ::AuthCache = CollectionSpace::AuthCache

      #
      # Map key constants for terms cache
      #
      AUTHORITIES_CACHE = 'authorities_cache'
      VOCABULARIES = "vocabularies"

      #
      # Pubic accessors to cached vocabularies and terms
      #
      def self.get_vocabularies
        Rails.cache.fetch(AuthCache::AUTHORITIES_CACHE)[AuthCache::VOCABULARIES]
      end

      def self.get_vocabulary(vocabulary_id)
        puts "Vocab ID is #{vocabulary_id}"
        get_vocabularies[vocabulary_id]
      end

      def self.setup(converter_module)
        begin
          file = File.join(Rails.root, 'config', 'initializers', 'converters', converter_module.downcase, 'auth_cache.json')
          puts "The file name is #{file}."
          authorities_cache = JSON.parse(File.read(file))
          # Use Rails to cache the authorities/vocabularies and terms 
          Rails.cache.write(AuthCache::AUTHORITIES_CACHE, authorities_cache)
        rescue Errno::ENOENT => e
          Rails.logger.warn "No authority cache file found at #{file}"
        end
      end

      #
      # Pubic accessor to cached vocabulary terms
      #
      def self.lookup_vocabulary_term_id(vocabulary_id, display_name)
        get_vocabulary(vocabulary_id)[display_name.downcase]
      end

      #
      # Pubic accessor to cached authority terms
      #
      def self.lookup_authority_term_id(authority_type, authority_id, display_name)
        term_id = nil
        begin
          term_id = Rails.cache.fetch(AUTHORITIES_CACHE)[authority_type][authority_id][display_name.downcase]
        rescue Exception => ex
          puts "Term #{authority_type}:#{authority_id}:#{display_name.downcase} is not in the authority cache."
        end

        return term_id
      end

    end

end
