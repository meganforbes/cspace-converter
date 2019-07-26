module CollectionSpace
  module Converter
    module Core
      include Default
      class CoreExhibition < Exhibition
        def convert
          run do |xml|
            CSXML.add xml, 'exhibitionNumber', attributes["exhibition_number"]
            CSXML.add xml, 'type', CSURN.get_vocab_urn('exhibitiontype', attributes["exhibition_type"].capitalize!)
            CSXML.add xml, 'title', attributes["exhibition_title"]
            CSXML.add_repeat xml, 'organizers', [{
              'organizer' =>  CSURN.get_authority_urn('orgauthorities', 'organization', attributes["organizer"])
            }]
            CSXML.add xml, 'boilerplateText', scrub_fields([attributes["boilerplate_text"]])
          end
        end
      end
    end
  end
end
