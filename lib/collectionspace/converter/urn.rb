module CollectionSpace
  module URN
    ::CSURN = CollectionSpace::URN
    def self.generate(domain, type, sub, identifier, label)
      "urn:cspace:#{domain}:#{type}:name(#{sub}):item:name(#{identifier})'#{label}'"
    end

    def self.get_authority_urn(authority, authority_subtype, display_name)
      id = AuthCache.authority(authority, authority_subtype, display_name)
      id ||= CSIDF.short_identifier(display_name)
      generate(
        Rails.application.config.domain,
        authority,
        authority_subtype,
        id,
        display_name
      )
    end

    def self.get_vocab_urn(vocabulary, display_name)
      identifier = AuthCache.vocabulary(vocabulary, display_name)
      identifier ||= display_name.downcase
      generate(
        Rails.application.config.domain,
        'vocabularies',
        vocabulary,
        identifier,
        display_name
      )
    end
  end
end
