module CollectionSpace
  module Converter
    module OHC
      include Default

      class OHCMedia < Media

        def convert
          run(wrapper: "document") do |xml|

            xml.send(
                "ns2:media_common",
                "xmlns:ns2" => "http://collectionspace.org/services/media",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              CSXML.add xml, 'identificationNumber', attributes["star_system_id"]
              CSXML.add xml, 'title', attributes["title"]
              CSXML.add xml, 'externalUrl', attributes["externalurl"]
              CSXML.add xml, 'description', scrub_fields([attributes["description"]])
            end
          end
        end

      end
    end
  end
end
