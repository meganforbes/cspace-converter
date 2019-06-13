module CollectionSpace
  module Converter
    module Core
      include Default

      class CoreIntake < Intake

        def convert
          run do |xml|
            #entryNumber
            CSXML.add xml, 'entryNumber', attributes["intake_entry_number"]

            #entryDate
            CSXML.add xml, 'entryDate', attributes["entry_date"]

            #entryReason
            CSXML.add xml, 'entryReason', attributes["entry_reason"].downcase!

            #currentOwner
            CSXML::Helpers.add_person xml, 'currentOwner', attributes["current_owner"] if attributes["current_owner"]

            #entryNote
            CSXML.add xml, 'entryNote', attributes["entry_note"]

            #packingNote
            CSXML.add xml, 'packingNote', attributes["packing_note"]

          end
        end
      end
    end
  end
end
