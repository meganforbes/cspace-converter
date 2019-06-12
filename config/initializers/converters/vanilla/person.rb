module CollectionSpace
  module Converter
    module Core
      include Default

      class CorePerson < Person

        def convert
          run do |xml|
            # CSXML.add xml, 'shortIdentifier', CSIDF.short_identifier(attributes["name"])

            term_short_id = self.term_short_id
            CSXML.add xml, 'shortIdentifier', term_short_id


            CSXML.add_group_list xml, 'personTerm',
                                 [{
                                      "termDisplayName" => attributes["termdisplayname"],
                                      "termType" => CSXML::Helpers.get_vocab_urn('persontermtype', attributes["termtype"]),
                                  }]
            puts term_short_id
          end
        end

      end

    end
  end
end
