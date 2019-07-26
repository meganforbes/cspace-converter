module CollectionSpace
  module Converter
    module PublicArt
      include Default
      COMMON_ERA_URN = "urn:cspace:publicart.collectionspace.org:vocabularies:name(dateera):item:name(ce)'CE'"
      class PublicArtCollectionObject < CollectionObject
        def convert
          run(wrapper: "document") do |xml|
            xml.send(
                "ns2:collectionobjects_common",
                "xmlns:ns2" => "http://collectionspace.org/services/collectionobject",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              # objectNumber
              CSXML.add xml, 'objectNumber', attributes["objectnumber"]

              # numberOfObjects
              CSXML.add xml, 'numberOfObjects', attributes["numberOfObjects"]

              CSXML.add_repeat xml, 'briefDescriptions', [{
                  "briefDescription" => scrub_fields([attributes["briefdescription"]])
              }]

              CSXML.add xml, 'recordStatus', attributes["recordStatus"]

              # objectNameList
              namegroups = []
              objectnames = split_mvf attributes, 'objectname'
              objectnamenotes = split_mvf attributes, 'objectnamenotes'
              objectnames.each_with_index do |name, index|
                namegroups << { "objectName" => name, "objectNameNote" => objectnamenotes[index] }
              end
              CSXML.add_group_list xml, 'objectName', namegroups, include_group_prefix:false

              # Title group list
              title_groups = []
              titles = split_mvf attributes, 'title'
              title_types = split_mvf attributes, 'titletype'
              titles.each_with_index do |title, index|
                title_groups << { "title" => title, "titleType" => title_types[index] }
              end
              CSXML.add_group_list xml, 'title', title_groups, include_group_prefix:true

              # materialGroupList
              mgs = []
              materials = split_mvf attributes, 'material'
              materials.each do |m|
                mgs << { "material" => CSURN.get_authority_urn('conceptauthorities', 'material_ca', m) }
                #mgs << { "material" => m }
              end
              CSXML.add_group_list xml, 'material', mgs

              # measuredPartGroupList
              overall_data = {
                  "measuredPart" => attributes["dimensionpart"],
                  "dimensionSummary" => attributes["dimensionsummary"],
              }
              dimensions = []
              dims = split_mvf attributes, 'dimension'
              values = split_mvf attributes, 'dimensionvalue'
              units = split_mvf attributes, "dimensionmeasurementunit"
              dims.each_with_index do |dim, index|
                dimensions << { "dimension" => dim, "value" => values[index], "measurementUnit" => units[index] }
              end
              CSXML.add_group_list xml, 'measuredPart', [ overall_data ], 'dimension', dimensions

              # textualInscriptionGroupList
              CSXML.add_group_list xml, 'textualInscription', [{
                inscriptionContentInscriber => CSURN.get_authority_urn('personauthorities', 'person', attributes["inscriber"]),
                inscriptionContentMethod => attributes["method"],
              }] if attributes["inscriber"]

              # objectProductionOrganizationGroupList
              CSXML.add_group_list xml, 'objectProductionOrganization', [{
                "objectProductionOrganization" => CSURN.get_authority_urn('orgauthorities', 'organization', attributes["production_org"]),
                "objectProductionOrganizationRole" => attributes["organization_role"],
              }] if attributes["production_org"]

              # objectProductionPeopleGroupList
              CSXML.add_group_list xml, 'objectProductionPeople', [{
                "objectProductionPeople" => attributes["production_people"]
              }] if attributes["production_people"]

              # objectProductionPlaceGroupList
              CSXML.add_group_list xml, 'objectProductionPlace', [{
                "objectProductionPlace" => attributes["production_place"]
              }] if attributes["production_place"]

              # owners (two CSV columns, owners_person and owners_org)
              owners_urns = []
              owners = split_mvf attributes, 'owners_person'
              owners.each do |owner|
                owners_urns << { "owner" => CSURN.get_authority_urn('personauthorities', 'person', owner) }
              end
              owners = split_mvf attributes, 'owners_org'
              owners.each do |owner|
                owners_urns << { "owner" => CSURN.get_authority_urn('orgauthorities', 'organization', owner) }
              end
              CSXML.add_repeat(xml, 'owners', owners_urns) if owners_urns.empty? == false

              # techniqueGroupList
              tgs = []
              techniques = split_mvf attributes, 'technique'
              techniques.each do |t|
                tgs << { "technique" => t }
              end
              CSXML.add_group_list xml, 'technique', tgs

              # objectStatusList
              CSXML.add_list xml, 'objectStatus', [{
                "objectStatus" => attributes["object_status"]
              }] if attributes["object_status"]

              # fieldColEventNames
              CSXML.add_repeat xml, 'fieldColEventNames', [{
                "fieldColEventName" => attributes["field_collection_event_name"]
              }]
            end

            #
            # Public Art extension fields
            #
            xml.send(
                "ns2:collectionobjects_publicart",
                "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/collectionobject",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil

              # Example XML payload
              #
              # Column 'objectProductionDate' should map to the <dateDisplayDate> element
              # Column 'objectProductionDateType' should map to the <publicartProductionDateType> element
              #
              # <publicartProductionDateGroupList>
              #     <publicartProductionDateGroup>
              #         <publicartProductionDate>
              #             <dateDisplayDate>7/4/1776</dateDisplayDate>
              #         </publicartProductionDate>
              #         <publicartProductionDateType>
              #             urn:cspace:publicart.collectionspace.org:vocabularies:name(proddatetype):item:name(commission)'commission'
              #         </publicartProductionDateType>
              #     </publicartProductionDateGroup>
              # </publicartProductionDateGroupList>
              #
              proddategroups = []
              proddates = split_mvf attributes, 'objectproductiondate'
              proddatetypes = split_mvf attributes, 'objectproductiondatetype'
              proddates.each_with_index do |date, index|
                proddategroups << { "publicartProductionDate" => date, "publicartProductionDateType" => proddatetypes[index] }
              end

              xml.send("publicartProductionDateGroupList".to_sym) {
                proddategroups.each do |element|
                  xml.send("publicartProductionDateGroup".to_sym) {
                    if !element["publicartProductionDate"].blank?
                      structured_date = CSDTP::parse element["publicartProductionDate"] if element["publicartProductionDate"]
                      if !structured_date.blank?
                        xml.send("publicartProductionDate".to_sym) {
                          xml.send("scalarValuesComputed".to_sym, "true")
                          xml.send("dateDisplayDate".to_sym, structured_date.display_date)

                          xml.send("dateEarliestSingleDay".to_sym, structured_date.earliest_day)
                          xml.send("dateEarliestSingleMonth".to_sym, structured_date.earliest_month)
                          xml.send("dateEarliestSingleYear".to_sym, structured_date.earliest_year)
                          xml.send("dateEarliestScalarValue".to_sym, structured_date.earliest_scalar)
                          xml.send("dateEarliestSingleEra".to_sym, COMMON_ERA_URN)

                          xml.send("dateLatestDay".to_sym, structured_date.latest_day)
                          xml.send("dateLatestMonth".to_sym, structured_date.latest_month)
                          xml.send("dateLatestYear".to_sym, structured_date.latest_year)
                          xml.send("dateLatestScalarValue".to_sym, structured_date.latest_scalar)
                          xml.send("dateLatestEra".to_sym, COMMON_ERA_URN)
                        }
                      else
                        xml.send("publicartProductionDate".to_sym) {
                          xml.send("dateDisplayDate".to_sym, element["publicartProductionDate"])
                        }
                      end
                    end
                    xml.send("publicartProductionDateType".to_sym, CSURN.get_vocab_urn('proddatetype', element["publicartProductionDateType"]))
                  }
                end
              }

              # Collection
              CSXML.add_repeat xml, 'publicartCollections', [{
                  "publicartCollection" => CSURN.get_authority_urn('orgauthorities', 'organization', attributes["collection"]),
              }] if attributes["collection"]

              # publicartProductionPersonGroupList
              prodpersongroups = []

              prodpersons_urns = []
              prodpersons = split_mvf attributes, 'objectproductionperson'
              prodpersons.each do |person, index|
                prodpersons_urns << CSURN.get_authority_urn('personauthorities', 'person', person)
              end

              role_urns = []
              roles = split_mvf attributes, 'objectproductionpersonrole'
              roles.each do |role, index|
                role_urns << CSURN.get_vocab_urn('prodpersonrole', role)
              end
              types = split_mvf attributes, 'objectproductionpersontype'

              # Build the multi-valued group
              prodpersons_urns.each_with_index do |person_urn, index|
                prodpersongroups << { "publicartProductionPerson" => person_urn, "publicartProductionPersonRole" => role_urns[index], "publicartProductionPersonType" => types[index] }
              end
              CSXML.add_group_list xml, 'publicartProductionPerson', prodpersongroups
            end
          end
        end
      end
    end
  end
end
