module CollectionSpace
  module Converter
    module Core
      include Default

      class CoreMedia < Media

        def convert
          run do |xml|
            CSXML.add xml, 'identificationNumber', attributes["identification_number"]
            CSXML.add xml, 'title', attributes["title"]
            CSXML.add xml, 'coverage', attributes["coverage"]
            CSXML.add xml, 'description', scrub_fields([attributes["description"]])
          end
        end

      end

    end
  end
end
