module CollectionSpace
  module Converter
    module PastPerfect
      include Default

      class PastPerfectCollectionObject < CollectionObject

        def convert
          run(wrapper: "document") do |xml|
            xml.send(
              "ns2:collectionobjects_common",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              CSXML.add xml, 'objectNumber', attributes["objectid"]

              CSXML.add_group_list xml, 'title', [{
                "title" => attributes["title"],
              }]

              # otherNumberList - NM
              previous_number = attributes["otherno"] ? attributes["otherno"] : attributes["oldno"]
              CSXML.add_list xml, 'otherNumber', [{
                "numberType" => CSXML::Helpers.get_vocab_urn('bmnumbertype', 'Previous'),
                "numberValue" => previous_number,
              }] if previous_number

              # editionNumber - NM
              edition = attributes["edition"] ? attributes["edition"] : attributes["origcopy"]
              CSXML.add xml, 'editionNumber', edition if edition

              # copyNumber - NM
              copy_number = attributes["frameno"] ? attributes["frameno"] : attributes["negno"]
              CSXML.add xml, "copyNumber", copy_number if copy_number

              # numberOfObjects (1?) n/a

              CSXML.add xml, 'recordStatus', 'new'

              # responsibleDepartments n/a

              collection = attributes["collection"]
              CSXML.add xml, 'collection', CSXML::Helpers.get_vocab_urn('bmcollection', collection) if collection

              CSXML.add_repeat xml, 'briefDescriptions', [{
                "briefDescription" => scrub_fields([attributes["descrip_"], attributes["subjects_"]])
              }]
              CSXML.add xml, 'distinguishingFeatures', scrub_fields([attributes["notes_"]])
              CSXML.add xml, 'physicalDescription', attributes["physchar"]
              CSXML.add xml, 'comments', scrub_fields([attributes["pubnotes_"]])

              # objectNameList
              objname = attributes["objname"]
              gparent = attributes["gparent"]
              # cleanup will deviate from generated authority, so do it later
              # gparent = gparent.gsub(/^\d+: /, '') if gparent
              parent  = attributes["parent"]

              objname_group = {}
              objname_group = objname_group.merge({
                "objectName" => CSXML::Helpers.get_authority_urn('conceptauthorities', 'objectname', objname),
              }) if objname

              objname_group = objname_group.merge({
                "objectNameSystem" => CSXML::Helpers.get_authority_urn('conceptauthorities', 'category', gparent),
              }) if gparent

              objname_group = objname_group.merge({
                "objectNameType" => CSXML::Helpers.get_authority_urn('conceptauthorities', 'subcategory', parent),
              }) if parent

              CSXML.add_list xml, 'objectName', [ objname_group ], 'Group' unless objname_group.empty?

              # objectHistoryNote
              CSXML.add xml, 'objectHistoryNote', scrub_fields([attributes["custodial"], attributes["provenanc_"]])

              if attributes.fetch("recfrom", nil)
                owners = split_mvf attributes, 'recfrom'
                CSXML::Helpers.add_persons xml, 'owner', owners, :add_repeat
              end

              CSXML.add xml, 'assocEventName', attributes["event"]

              # assocPlaceGroupList: place; origin
              assoc_place = []
              assoc_place << {
                "assocPlaceNote" => "Place", "assocPlace" => attributes["place"]
              } if attributes["place"]
              assoc_place << {
                "assocPlaceNote" => "Origin", "assocPlace" => attributes["origin"]
              } if attributes["origin"]
              CSXML.add_group_list xml, 'assocPlace', assoc_place

              # assocPersonGroupList (x 2): collector; owned; used; found
              assoc_person = []
              assoc_person << {
                "assocPersonNote" => "Collector",
                "assocPerson" => CSXML::Helpers.get_authority_urn('personauthorities', 'person', attributes["collector"]),
              } if attributes["collector"]
              assoc_person << {
                "assocPersonNote" => "Owned",
                "assocPerson" => CSXML::Helpers.get_authority_urn('personauthorities', 'person', attributes["owned"]),
              } if attributes["owned"]
              assoc_person << {
                "assocPersonNote" => "Used",
                "assocPerson" => CSXML::Helpers.get_authority_urn('personauthorities', 'person', attributes["used"]),
              } if attributes["used"]
              assoc_person << {
                "assocPersonNote" => "Found",
                "assocPerson" => CSXML::Helpers.get_authority_urn('personauthorities', 'person', attributes["found"]),
              } if attributes["found"]
              CSXML.add_group_list xml, 'assocPerson', assoc_person

              # assocOrganizationGroupList: studio
              CSXML.add_group_list xml, 'assocOrganization', [{
                "assocOrganization" => CSXML::Helpers.get_authority_urn('orgauthorities', 'organization', attributes["studio"]),
                "assocOrganizationNote" => "Studio",
              }] if attributes["studio"]

              # objectProductionDateGroupList: earlydate; made; date; pubdate
              display_date = attributes["made"] ? attributes["made"] : attributes["pubdate"]
              CSXML.add_group_list xml, "objectProductionDate", [{
                "dateDisplayDate" => display_date,
                "dateEarliestSingleYear" => attributes["earlydate"],
              }]

              # objectProductionPlaceGroupList: pubplace
              CSXML.add_group_list xml, 'objectProductionPlace', [{
                "objectProductionPlaceRole" => "Pub Place",
                "objectProductionPlace" => attributes["pubplace"]
              }] if attributes["pubplace"]

              # objectProductionPersonGroupList: artist; author; phtgrapher
              object_prod_person = []
              ["artist", "artist2", "artist3"].each do |artist|
                object_prod_person << {
                  "objectProductionPerson" => CSXML::Helpers.get_authority_urn('personauthorities', 'person', attributes[artist]),
                  "objectProductionPersonRole" => "artist",
                } if attributes[artist]
              end
              object_prod_person << {
                "objectProductionPerson" => CSXML::Helpers.get_authority_urn('personauthorities', 'person', attributes["author"]),
                "objectProductionPersonRole" => "author",
              } if attributes["author"]
              object_prod_person << {
                "objectProductionPerson" => CSXML::Helpers.get_authority_urn('personauthorities', 'person', attributes["phtgrapher"]),
                "objectProductionPersonRole" => "photographer",
              } if attributes["phtgrapher"]
              CSXML.add_group_list xml, 'objectProductionPerson', object_prod_person


              # objectProductionOrganizationGroupList: publisher
              CSXML.add_group_list xml, 'objectProductionOrganization', [{
                "objectProductionOrganization" => CSXML::Helpers.get_authority_urn('orgauthorities', 'organization', attributes["publisher"]),
                "objectProductionOrganizationRole" => "Publisher",
              }] if attributes["publisher"]

              # ownershipExchangeMethod: recas
              CSXML.add xml, 'ownershipExchangeMethod', attributes["recas"]
              # ownershipExchangePriceValue: price
              CSXML.add xml, 'ownershipExchangePriceValue', attributes["price"]

              # materialGroupList: material; medium
              CSXML.add_group_list xml, 'materialGroup', [{
                "material" => attributes["material"],
                "materialName" => attributes["medium"],
              }]

              # textualInscriptionGroupList: signedname
              signed_name = attributes["signedname"]
              CSXML.add_group_list xml, 'textualInscription', [{
                "inscriptionContent" => signed_name,
                "inscriptionContentType" => CSXML::Helpers.get_vocab_urn('inscriptioncontenttype', 'signature'),
                "inscriptionContentPosition" => CSXML::Helpers.get_vocab_urn('inscriptioncontentposition', attributes.fetch("signloc", "back")),
              }] if signed_name

              # measuredPartGroupList: overall
              measured_part = {
                "measuredPart" => "overall"
              }
              # depthin, heightin, widthin
              framed        = attributes["framed"] && attributes["framed"] == "yes" ? true : false
              measured_part = measured_part.merge({ "dimensionSummary" => "framed" }) if framed
              height        = { "dimension" => "height", "value" => attributes.fetch("heightin", "0"), "measurementUnit" => "inches" }
              width         = { "dimension" => "width", "value" => attributes.fetch("widthin", "0"), "measurementUnit" => "inches" }
              depth         = { "dimension" => "depth", "value" => attributes.fetch("depthin", "0"), "measurementUnit" => "inches" }
              dimensions    = [ height, width, depth ]
              CSXML.add_group_list xml, 'measuredPart', [ measured_part ], 'dimension', dimensions
            end

            xml.send(
              "ns2:collectionobjects_bm",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/local/bm",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              CSXML.add xml, 'conditionStatus', CSXML::Helpers.get_vocab_urn('conditionstatus', 'Exhibitable/Needs no work')
              CSXML.add xml, 'approvedForWeb', "false"
            end

            xml.send(
              "ns2:collectionobjects_fineart",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/collectionobject",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              CSXML.add xml, 'materialTechniqueDescription', attributes["process"]
              CSXML.add xml, 'catalogLevel', CSXML::Helpers.get_vocab_urn('cataloglevel', ' item ', true)
              # creatorDescription: copyright
              CSXML.add xml, 'creatorDescription', attributes["copyright"]
            end

            xml.send(
              "ns2:collectionobjects_variablemedia",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/collectionobject",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
            end
          end
        end

      end

    end
  end
end