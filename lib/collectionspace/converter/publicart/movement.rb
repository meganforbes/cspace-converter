module CollectionSpace
  module Converter
    module PublicArt
      include Default
      class PublicArtMovement < Movement
        def convert
          run do |xml|
            CSXML.add xml, 'movementReferenceNumber', attributes["movementreferencenumber"]

            # location, currentLocation
            current_location = attributes['currentlocation']
            if current_location
              CSXML::Helpers.add_place xml, 'currentLocation', current_location
            end

            CSXML.add xml, 'locationDate', attributes["location_date"]

            CSXML::Helpers.add_persons xml, 'borrowersAuthorizer', [attributes["movement_contact"]]

            CSXML.add xml, 'reasonForMove', attributes["reason_for_move"]

            CSXML.add xml, 'movementNote', scrub_fields([attributes["movementnote"]])

            CSXML.add xml, 'currentLocationNote', scrub_fields([attributes["currentlocationnote"]])
          end
        end
      end
    end
  end
end
