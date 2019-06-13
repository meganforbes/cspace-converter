module CollectionSpace
  module Converter
    module PublicArt
      include Default

      class PublicArtPlace < Place

        def convert
          run(wrapper: "document") do |xml|

            xml.send(
                "ns2:places_common",
                "xmlns:ns2" => "http://collectionspace.org/services/place",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil

              CSXML.add xml, 'shortIdentifier', CSIDF.short_identifier(attributes["termdisplayname"])

              CSXML.add_group_list xml, 'addr',
                                   [{
                                        "addressPlace1" => attributes["addressplace1"],
                                        "addressPlace2" => attributes["addressplace2"],
                                        "addressCountry" => attributes["addresscountry"],
                                        "addressMunicipality" => attributes["addressmunicipality"],
                                        "addressStateOrProvince" => attributes["addressstateorprovince"],
                                        "addressPostCode" => attributes["addresspostcode"],
                                        "addressType" => CSXML::Helpers.get_vocab_urn('addresstype', attributes["addresstype"])

                                    }]

              CSXML.add_group_list xml, 'placeTerm',
                                   [{
                                        "termDisplayName" => attributes["termdisplayname"],
                                    }]

              CSXML.add_group_list xml, 'placeGeoRef',
                                   [{
                                        "decimalLatitude" => attributes["decimallatitude"],
                                        "decimalLongitude" => attributes["decimallongitude"],
                                    }]
            end

            xml.send(
                "ns2:places_publicart",
                "xmlns:ns2" => "http://collectionspace.org/services/place/local/publicart",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil

              # placementTypes
              placement_types_urns = []
              placement_types = split_mvf attributes, 'placementtype'
              placement_types.each do | placement_type |
                placement_types_urns << { "placementType" => CSXML::Helpers.get_vocab_urn('placementtypes', placement_type) }
              end
              CSXML.add_repeat(xml, 'placementTypes', placement_types_urns) if attributes["placementtype"]
            end

          end
        end

      end

    end
  end
end
