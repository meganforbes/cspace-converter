module CollectionSpace
  module Converter
    module PublicArt
      include Default

      DEFAULT_PLACE_AUTHORITY_ID = 'place_shared'

      class PublicArtMovement < Movement

        def convert
          run do |xml|
            CSXML.add xml, 'movementReferenceNumber', attributes["movementreferencenumber"]

            # location, currentLocation
            current_location = attributes['currentlocation']
            if current_location
              CSXML::Helpers.get_authority_urn('placeauthorities', DEFAULT_PLACE_AUTHORITY_ID, current_location)
            end
            
            CSXML.add xml, 'locationDate', attributes["location_date"]

            CSXML.add xml, 'reasonForMove', attributes["reason_for_move"]

            CSXML.add xml, 'movementNote', scrub_fields([attributes["movementnote"]])

            CSXML.add xml, 'currentLocationNote', scrub_fields([attributes["currentlocationnote"]])
          end

        end
      end
    end
  end
end
