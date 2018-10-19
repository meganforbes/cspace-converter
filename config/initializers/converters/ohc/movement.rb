module CollectionSpace
  module Converter
    module OHC
      include Default

      class OHCMovement < Movement

        def convert
          run do |xml|
            CSXML.add xml, 'movementReferenceNumber', attributes["reference_number"]

            # location, currentLocation
            current_location = attributes['current_location']
            if current_location
              CSXML::Helpers.add_location xml, 'currentLocation', current_location
            end

            CSXML.add xml, 'currentLocationNote', scrub_fields([attributes["location_note"]])

            if attributes["location_date"]
              structured_date = CSDTP::parse attributes["location_date"]
              parsedDate = structured_date.parsed_datetime.strftime('%m/%d/%Y')
              CSXML.add xml, 'locationDate', parsedDate
            end

            if attributes["movement_date"]
              structured_date = CSDTP::parse attributes["movement_date"]
              parsedDate = structured_date.parsed_datetime.strftime('%m/%d/%Y')
              CSXML.add xml, 'removalDate', parsedDate
            end

            normal_location = attributes['normal_location']
            if normal_location
              CSXML::Helpers.add_location xml, 'normalLocation', normal_location
            end

            # inventoryContactList
            tgs = []
            contacts = split_mvf attributes, 'inventory_contact'
            contacts.each do |t|
              tgs << { "inventoryContact" => CSXML::Helpers.get_authority_urn('personauthorities', 'person', t) }
            end
            CSXML.add_repeat xml, 'inventoryContact', tgs, 'List'

          end

        end
      end
    end
  end
end
