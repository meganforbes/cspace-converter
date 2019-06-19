module CollectionSpace
  module Converter
    module Default
      def self.registered_procedures
        []
      end

      def self.registered_profiles
        {}
      end

      # TODO: move this to config
      # used for remote actions
      # subtype is defined for authority records to target a specific authority (sub)type
      def self.service(type, subtype)
        {
          "Acquisition" => {
            path: "acquisitions", schema: "acquisitions"
          },
          "CollectionObject" => {
            path: "collectionobjects", schema: "collectionobjects"
          },
          "Concept" => {
            id: "conceptauthorities", path: "conceptauthorities/urn:cspace:name(#{subtype})/items", schema: "concepts"
          },
          "ConditionCheck" => {
            path: "conditionchecks", schema: "conditionchecks"
          },
          "Conservation" => {
            path: "conservation", schema: "conservation"
          },
          "Exhibition" => {
            path: "exhibitions", schema: "exhibitions"
          },
          "Group" => {
            path: "groups", schema: "groups"
          },
          "Intake" => {
            path: "intakes", schema: "intakes"
          },
          "LoanIn" => {
            path: "loansin", schema: "loansin"
          },
          "LoanOut" => {
            path: "loansout", schema: "loansout"
          },
          "Location" => {
              id: "locationauthorities", path: "locationauthorities/urn:cspace:name(#{subtype})/items", schema: "locations"
          },
          "Media" => {
            path: "media", schema: "media"
          },
          "Movement" => {
            path: "movements", schema: "movements"
          },
          "ObjectExit" => {
            path: "objectexit", schema: "objectexit"
          },
          "Organization" => {
            id: "orgauthorities", path: "orgauthorities/urn:cspace:name(#{subtype})/items", schema: "organizations"
          },
          "Person" => {
              id: "personauthorities", path: "personauthorities/urn:cspace:name(#{subtype})/items", schema: "persons"
          },
          "Place" => {
              id: "placeauthorities", path: "placeauthorities/urn:cspace:name(#{subtype})/items", schema: "places"
          },
          "Relationship" => {
            path: "relations", schema: "relations"
          },
          "Taxon" => {
            path: "taxonomyauthority/urn:cspace:name(#{subtype})/items", schema: "taxon"
          },
          "ValuationControl" => {
            path: "valuationcontrols", schema: "valuationcontrols"
          },
        }[type]
      end

      def self.validate_authority!(authority)
        unless [ "Concept", "Location", "Material", "Materials", "Person", "Place", "Organization", "Taxon", "Work" ].include? authority
          raise "Invalid authority #{authority}"
        end
      end

      # set which procedures can be created from model
      def self.validate_procedure!(procedure, converter)
        valid_procedures = converter.registered_procedures
        unless valid_procedures.include?("all") or valid_procedures.include?(procedure)
          raise "Invalid procedure #{procedure}, not permitted by configuration."
        end
      end
    end
  end
end
