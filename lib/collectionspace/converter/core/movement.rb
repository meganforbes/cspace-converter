module CollectionSpace
  module Converter
    module Core
      include Default
      class CoreMovement < Movement
        def convert
          run do |xml|
            CSXML.add xml, 'movementReferenceNumber', attributes["inventory_reference_number"]
            current_location = attributes['current_location']
            if current_location
              CSXML::Helpers.add_location xml, 'currentLocation', current_location
            end
            CSXML.add xml, 'locationDate', attributes["location_date"]
            CSXML::Helpers.add_persons xml, 'borrowersAuthorizer', [attributes["movement_contact"]]
            CSXML.add xml, 'reasonForMove', attributes["reason_for_move"]
            CSXML.add xml, 'movementNote', scrub_fields([attributes["movement_information_note"]])
          end
        end
      end
    end
  end
end
