module CollectionSpace
  module Converter
    module Core
      include Default

      class CoreConcept < Concept

        def convert
          run do |xml|
            # TODO: refactor
            # term_parts = CSURN.get_term_parts attributes["termdisplayname"]
            # term_id = term_parts[:term_id]
            # if term_id == nil
            #   term_id = AuthCache.authority 'conceptauthorities', 'material_ca', term_parts[:display_name]
            # end

            # if term_id == nil
            #   CSXML.add xml, 'shortIdentifier', CSIDF.short_identifier(attributes["termdisplayname"])
            # else
            #   CSXML.add xml, 'shortIdentifier', term_id
            # end

            # CSXML.add_group_list xml, 'conceptTerm', [{
            #                                               "termDisplayName" => attributes["termdisplayname"],
            #                                               "termSourceDetail" => attributes["termsourcedetail"],
            #                                               "termSource" => CSURN.get_authority_urn('citationauthorities', 'citation', attributes["termsource"])
            #                                           }]
          end
        end

      end

    end
  end
end
