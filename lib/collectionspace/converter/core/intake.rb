module CollectionSpace
  module Converter
    module Core
      include Default
      class CoreIntake < Intake
        def convert
          run do |xml|
            CSXML.add xml, 'entryNumber', attributes["intake_entry_number"]
            CSXML.add xml, 'entryDate', attributes["entry_date"]
            CSXML.add xml, 'entryReason', attributes["entry_reason"].downcase!
            CSXML::Helpers.add_person xml, 'currentOwner', attributes["current_owner"] if attributes["current_owner"]
            CSXML.add xml, 'entryNote', attributes["entry_note"]
            CSXML.add xml, 'packingNote', attributes["packing_note"]
          end
        end
      end
    end
  end
end
