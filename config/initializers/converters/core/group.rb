module CollectionSpace
  module Converter
    module Core
      include Default

      class CoreGroup < Group

        def convert
          run do |xml|
            #owner
            CSXML::Helpers.add_persons xml, 'owner', [attributes["owner"]]

            #loanInDate
            CSXML.add xml, 'title', attributes["title"]

            #loanInNote
            CSXML.add xml, 'scopeNote', scrub_fields([attributes["scope_note"]])

          end
        end

      end

    end
  end
end
