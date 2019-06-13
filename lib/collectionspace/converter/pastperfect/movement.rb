module CollectionSpace
  module Converter
    module PastPerfect
      include Default

      class PastPerfectMovement < Movement

        def convert
          run do |xml|
            CSXML.add xml, 'movementReferenceNumber', attributes["objectid"]
            # permloc, normalLocation
            normal_location = attributes["permloc"]
            CSXML::Helpers.add_location xml, 'normalLocation', normal_location if normal_location

            # location, currentLocation
            current_location = attributes["location"]
            if current_location
              CSXML::Helpers.add_location xml, 'currentLocation', current_location
              CSXML.add xml, 'currentLocationFitness', 'suitable'
            end
          end
        end

      end

    end
  end
end