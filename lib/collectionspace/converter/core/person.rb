module CollectionSpace
  module Converter
    module Core
      include Default

      class CorePerson < Person

        def convert
          run do |xml|
            CSXML.add xml, 'shortIdentifier', CSIDF.short_identifier(attributes["termdisplayname"])
            CSXML.add_group_list xml, 'personTerm',
                                 [{
                                      "termDisplayName" => attributes["termdisplayname"],
                                      "termType" => CSURN.get_vocab_urn('persontermtype', attributes["termtype"], true),
                                  }]
          end
        end

      end

    end
  end
end
