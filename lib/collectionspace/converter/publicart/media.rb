module CollectionSpace
  module Converter
    module PublicArt
      include Default
      class PublicArtMedia < Media
        def convert
          run(wrapper: "document") do |xml|

            xml.send(
                "ns2:media_common",
                "xmlns:ns2" => "http://collectionspace.org/services/media",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              CSXML.add xml, 'identificationNumber', attributes["identificationnumber"]
              CSXML.add xml, 'title', attributes["title"]
              CSXML.add xml, 'externalUrl', attributes["externalurl"]
              CSXML.add xml, 'description', scrub_fields([attributes["description"]])
            end

            xml.send(
                "ns2:media_publicart",
                "xmlns:ns2" => "http://collectionspace.org/services/media/local/publicart",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do

              #
              # publicartRightsHolders (two CSV columns, rights_holder_org and owners_org)
              #
              rightsholders_urns = []
              rightsholders = split_mvf attributes, 'rightsholder_person'
              rightsholders.each do | rightsholder |
                rightsholders_urns << { "publicartRightsHolder" => CSURN.get_authority_urn('personauthorities', 'person', rightsholder) }
              end
              rightsholders = split_mvf attributes, 'rightsholder_org'
              rightsholders.each do |rightsholder|
                rightsholders_urns << { "publicartRightsHolder" => CSURN.get_authority_urn('orgauthorities', 'organization', rightsholder) }
              end
              CSXML.add_repeat(xml, 'publicartRightsHolders', rightsholders_urns) if rightsholders_urns.empty? == false

              #
              # publishToList
              #
              publishto_urns = []
              publishto_list = split_mvf attributes, 'publishto'
              publishto_list.each do | publishto |
                publishto_urns << { "publishTo" => CSURN.get_vocab_urn('publishto', publishto) }
              end
              if publishto_urns.empty? == false
                puts publishto_urns
              end
              CSXML.add_repeat(xml, 'publishToList', publishto_urns) if publishto_urns.empty? == false
            end
          end
        end
      end
    end
  end
end
