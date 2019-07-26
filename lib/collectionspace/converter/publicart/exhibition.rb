module CollectionSpace
  module Converter
    module PublicArt
      include Default
      class PublicArtExhibition < Exhibition
        def convert
          run do |xml|
            #exhibitionNumber
            CSXML.add xml, 'exhibitionNumber', attributes["exhibition_number"]

            #type
            CSXML.add xml, 'type', CSURN.get_vocab_urn('exhibitiontype', attributes["exhibition_type"].capitalize!)

            #title
            CSXML.add xml, 'title', attributes["exhibition_title"]

            #organizers
            CSXML.add_repeat xml, 'organizers', [{
              'organizer' =>  CSURN.get_authority_urn('orgauthorities', 'organization', attributes["organizer"])
            }]

            #boilerplateText
            CSXML.add xml, 'boilerplateText', scrub_fields([attributes["boilerplate_text"]])
          end
        end
      end
    end
  end
end
