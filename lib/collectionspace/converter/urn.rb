module CollectionSpace
  module URN
    ::CSURN = CollectionSpace::URN
    def self.generate(domain, type, sub, identifier, label)
      "urn:cspace:#{domain}:#{type}:name(#{sub}):item:name(#{identifier})'#{label}'"
    end

    #
    # Get (or create) a URN for an authority term value
    #
    def self.get_authority_urn(authority_type, authority_id, value, fail_on_missing = false)
      if value
        term_parts = get_term_parts value

        display_name = term_parts[:display_name]
        raise ArgumentError, 'Display name for authority term is missing.' unless display_name != nil

        authority_id = term_parts[:authority_id] != nil ? term_parts[:authority_id] : authority_id
        raise ArgumentError, 'Authority short ID is missing or empty.' unless authority_id != nil

        term_id = term_parts[:term_id]
        if term_id == nil
          term_id = AuthCache::lookup_authority_term_id authority_type, authority_id, display_name
        end

        #
        # If the caller didn't supply a short ID and we couldn't find an existing one then
        # we need to create one.
        #
        if term_id == nil
          if fail_on_missing == false
            term_id = CollectionSpace::Identifiers.short_identifier(display_name)
          else
            raise ArgumentError, sprintf("The %s term with display name '%s' needs to, but does not, exist.", authority_type, display_name)
          end
        end

        generate(
          Rails.application.config.domain,
          authority_type,
          authority_id,
          term_id,
          display_name
        )
      end
    end

    #
    # Add split a term value into parts and add to a map
    #
    def self.get_term_parts(field_value)
      parts = split_term field_value
      parts_map = {:display_name => parts.pop, :term_id => parts.pop, :authority_id => parts.pop,
                    :authority_type => parts.pop}
    end


    #
    # Get the URN for a vocabulary term value
    #
    def self.get_vocab_urn(vocabulary_id, value, row_number = "unknown")
      if value
        # try to breakup the term value into component parts
        term_parts = get_term_parts value

        display_name = term_parts[:display_name]
        raise ArgumentError, 'Display name for vocabulary term is missing.' unless display_name != nil

        vocabulary_id = term_parts[:authority_id] != nil ? term_parts[:authority_id] : vocabulary_id
        raise ArgumentError, 'Vocabulary short ID is missing or empty.' unless vocabulary_id != nil

        term_id = term_parts[:term_id]
        if term_id == nil
          term_id = AuthCache::lookup_vocabulary_term_id vocabulary_id, display_name
        end
        Rails.logger.error "Problem in row #{row_number} because vocabulary short ID for term '#{display_name}' does not exist or was not provided." unless term_id != nil

        generate(
          Rails.application.config.domain,
          'vocabularies',
          vocabulary_id,
          term_id,
          display_name
        )
      end
    end

    #
    # Split a term value into parts -if any.
    #   <authority_type>::<authority_id>::<term_id>::<display_name>
    #   Ex #1: personauthorities::person::john_muir::John Muir
    #   Ex #2: john_muir::John Muir
    #   Ex #3: John Muir
    #
    def self.split_term(field_value)
      values = []
      values << field_value
                    .to_s
                    .split("::")
                    .map(&:strip)
      values.flatten.compact
    end
  end
end
