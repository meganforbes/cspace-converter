module CollectionSpace
  module Converter
    module OHC

      def self.registered_procedures
        [
          "CollectionObject",
          "Media",
          "Movement",
        ]
      end

      def self.registered_profiles
        {
          "cataloging" => {
            "Procedures" => {
              "CollectionObject" => {
                "identifier_field" => "objectNumber",
                "identifier" => "object_number",
                "title" => "title",
              },
            },
            "Authorities" => {
              "Person" => ["content_person", "inscriber", "objectproductionperson", "owners_person"],
              "Organization" => ["production_org", "owners_org"],
              "Concept" => [["material", "material_ca"]],
            },
            "Relationships" => [
              {
              },
            ],
          },
           "media" => {
             "Procedures" => {
               "Media" => {
                 "identifier_field" => "identificationNumber",
                 "identifier" => "star_system_id",
                 "title" => "star_system_id",
               },
             },
             "Authorities" => {
             },
             "Relationships" => [
               {
                 "procedure1_type" => "CollectionObject",
                 "data1_field" => "object_number",
                 "procedure2_type" => "Media",
                 "data2_field" => "star_system_id",
               },
             ],
           },
          "movement" => {
              "Procedures" => {
                  "Movement" => {
                      "identifier_field" => "movementReferenceNumber",
                      "identifier" => "reference_number",
                      "title" => "reference_number",
                  },
              },
              "Authorities" => {
                  "Person" => ["inventory_contact"],
              },
              "Relationships" => [
                  {
                      "procedure1_type" => "CollectionObject",
                      "data1_field" => "object_number",
                      "procedure2_type" => "Movement",
                      "data2_field" => "reference_number",
                  },
              ],
          },

        }
      end

    end
  end
end
