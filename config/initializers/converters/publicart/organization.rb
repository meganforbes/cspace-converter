module CollectionSpace
  module Converter
    module PublicArt
      include Default

      class PublicArtOrganization < Organization

        def convert
          run(wrapper: "document") do |xml|

            xml.send(
                "ns2:organizations_common",
                "xmlns:ns2" => "http://collectionspace.org/services/organization",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil

              CSXML.add xml, 'shortIdentifier', CSIDF.short_identifier(attributes["name"])

              CSXML.add_group_list xml, 'orgTerm',
                                   [{
                                        "termDisplayName" => attributes["termdisplayname"],
                                        "mainBodyName" => attributes["mainbodyname"],
                                    }]
            end

            xml.send(
                "ns2:organizations_publicart",
                "xmlns:ns2" => "http://collectionspace.org/services/organization/local/publicart",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil

              CSXML.add xml, 'currentPlace', CSXML::Helpers.get_authority_urn('placeauthorities', 'place', attributes["currentPlace"])
            end

            xml.send(
                "ns2:contacts_common",
                "xmlns:ns2" => "http://collectionspace.org/services/contact",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil

              # webaddress
              CSXML.add_group_list xml, 'webAddress',
                                   [{
                                        "webAddress" => attributes["webaddress"],
                                        "webAddressType" => attributes["webaddresstype"],
                                    }]
            end

          end
        end

      end

    end
  end
end
