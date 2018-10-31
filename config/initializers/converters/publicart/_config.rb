module CollectionSpace
  module Converter
    module PublicArt

      def self.registered_procedures
        [
          "CollectionObject",
          "Exhibition",
          "LoanIn",
          "LoanOut",
          "Media",
          "Intake",
          "Acquisition",
          "Group",
          "ValuationControl",
          "Movement",
          "ConditionCheck",
          "ObjectExit",
        ]
      end

      def self.registered_profiles
        {
          "cataloging" => {
            "Procedures" => {
              "CollectionObject" => {
                "identifier_field" => "objectNumber",
                "identifier" => "objectnumber",
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
          "conditioncheck" => {
            "Procedures" => {
              "ConditionCheck" => {
                "identifier_field" => "conditionCheckRefNumber",
                "identifier" => "condition_check_reference_number",
                "title" => "condition_check_reference_number",
               },
             },
             "Authorities" => {
               "Person" => ["condition_checker"],
             },
             "Relationships" => [
               {
                  "procedure1_type" => "CollectionObject",
                  "data1_field" => "relationship_1",
                  "procedure2_type" => "ConditionCheck",
                  "data2_field" => "condition_check_reference_number",
               },
               {
                  "procedure1_type" => "Movement",
                  "data1_field" => "relationship_2",
                  "procedure2_type" => "ConditionCheck",
                  "data2_field" => "condition_check_reference_number",
               },
             ],
           },
          "exhibition" => {
            "Procedures" => {
              "Exhibition" => {
                "identifier_field" => "exhibitionNumber",
                "identifier" => "exhibition_number",
                "title" => "exhibition_number",
              },
            },
            "Authorities" => {
              "Organization" => ["organizer"],
            },
            "Relationships" => [
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_1",
                "procedure2_type" => "Exhibition",
                "data2_field" => "exhibition_number",
              },
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_2",
                "procedure2_type" => "Exhibition",
                "data2_field" => "exhibition_number",
              },
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_3",
                "procedure2_type" => "Exhibition",
                "data2_field" => "exhibition_number",
              },
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_4",
                "procedure2_type" => "Exhibition",
                "data2_field" => "exhibition_number",
              },
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_5",
                "procedure2_type" => "Exhibition",
                "data2_field" => "exhibition_number",
              },
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_6",
                "procedure2_type" => "Exhibition",
                "data2_field" => "exhibition_number",
              },
            ],
          },
          "group" => {
            "Procedures" => {
              "Group" => {
                "identifier_field" => "title",
                "identifier" => "title",
                "title" => "title",
              },
            },
            "Authorities" => {
              "Person" => ["owner"],
            },
            "Relationships" => [
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_1",
                "procedure2_type" => "Group",
                "data2_field" => "title",
              },
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_2",
                "procedure2_type" => "Group",
                "data2_field" => "title",
              },
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_3",
                "procedure2_type" => "Group",
                "data2_field" => "title",
              },
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_4",
                "procedure2_type" => "Group",
                "data2_field" => "title",
              },
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_5",
                "procedure2_type" => "Group",
                "data2_field" => "title",
              },
            ],
          },
          "loanin" => {
            "Procedures" => {
              "LoanIn" => {
                "identifier_field" => "loanInNumber",
                "identifier" => "loan_in_number",
                "title" => "loan_in_number",
               },
             },
             "Authorities" => {
               "Person" => ["lender's_authorizer", "borrower's_authorizer"],
               "Organization" => ["lender"],
             },
             "Relationships" => [
               {
                  "procedure1_type" => "CollectionObject",
                  "data1_field" => "relationship_1",
                  "procedure2_type" => "LoanIn",
                  "data2_field" => "loan_in_number",
               },
               {
                  "procedure1_type" => "CollectionObject",
                  "data1_field" => "relationship_2",
                  "procedure2_type" => "LoanIn",
                  "data2_field" => "loan_in_number",
               },
               {
                  "procedure1_type" => "CollectionObject",
                  "data1_field" => "relationship_3",
                  "procedure2_type" => "LoanIn",
                  "data2_field" => "loan_in_number",
               },
             ],
           },
           "loanout" => {
             "Procedures" => {
               "LoanOut" => {
                 "identifier_field" => "loanOutNumber",
                 "identifier" => "loan_out_number",
                 "title" => "loan_out_number",
               },
             },
             "Authorities" => {
               "Person" => ["lender's_authorizer", "borrower's_authorizer"],
               "Organization" => ["borrower"],
             },
             "Relationships" => [
               {
                  "procedure1_type" => "CollectionObject",
                  "data1_field" => "relationship_1",
                  "procedure2_type" => "LoanOut",
                  "data2_field" => "loan_out_number",
               },
               {
                  "procedure1_type" => "CollectionObject",
                  "data1_field" => "relationship_2",
                  "procedure2_type" => "LoanOut",
                  "data2_field" => "loan_out_number",
               },
               {
                  "procedure1_type" => "CollectionObject",
                  "data1_field" => "relationship_3",
                  "procedure2_type" => "LoanOut",
                  "data2_field" => "loan_out_number",
               },
             ],
           },
           "media" => {
             "Procedures" => {
               "Media" => {
                 "identifier_field" => "identificationNumber",
                 "identifier" => "identificationnumber",
                 "title" => "identificationnumber",
               },
             },
             "Authorities" => {
             },
             "Relationships" => [
               {
                 "procedure1_type" => "CollectionObject",
                 "data1_field" => "relationship",
                 "procedure2_type" => "Media",
                 "data2_field" => "identificationnumber",
               },
             ],
           },
           "movement" => {
             "Procedures" => {
               "Movement" => {
                 "identifier_field" => "movementReferenceNumber",
                 "identifier" => "movementreferencenumber",
                 "title" => "movementreferencenumber",
               },
             },
             "Authorities" => {
               "Person" => ["movement_contact"],
             },
             "Relationships" => [
               {
                  "procedure1_type" => "CollectionObject",
                  "data1_field" => "relationship",
                  "procedure2_type" => "Movement",
                  "data2_field" => "movementreferencenumber",
               },
             ],
           },
           "intake" => {
             "Procedures" => {
               "Intake" => {
                 "identifier_field" => "entryNumber",
                 "identifier" => "intake_entry_number",
                 "title" => "intake_entry_number",
               },
             },
             "Authorities" => {
              "Person" => ["current_owner"],
             },
             "Relationships" => [
               {
                 "procedure1_type" => "CollectionObject",
                 "data1_field" => "relationship_1",
                 "procedure2_type" => "Intake",
                 "data2_field" => "intake_entry_number",
               },
               {
                 "procedure1_type" => "CollectionObject",
                 "data1_field" => "relationship_2",
                 "procedure2_type" => "Intake",
                 "data2_field" => "intake_entry_number",
               },
               {
                 "procedure1_type" => "CollectionObject",
                 "data1_field" => "relationship_3",
                 "procedure2_type" => "Intake",
                 "data2_field" => "intake_entry_number",
               },
               {
                 "procedure1_type" => "Media",
                 "data1_field" => "relationship_4",
                 "procedure2_type" => "Intake",
                 "data2_field" => "intake_entry_number",
               },
               {
                 "procedure1_type" => "Media",
                 "data1_field" => "relationship_5",
                 "procedure2_type" => "Intake",
                 "data2_field" => "intake_entry_number",
               },
             ],
           },
           "objectexit" => {
             "Procedures" => {
               "ObjectExit" => {
                 "identifier_field" => "exitNumber",
                 "identifier" => "exit_number",
                 "title" => "exit_number",
               },
             },
             "Authorities" => {
              "Organization" => ["current_owner"],
             },
             "Relationships" => [
               {
                 "procedure1_type" => "CollectionObject",
                 "data1_field" => "relationship_1",
                 "procedure2_type" => "ObjectExit",
                 "data2_field" => "exit_number",
               },
             ],
           },
           "acquisition" => {
             "Procedures" => {
               "Acquisition" => {
                 "identifier_field" => "acquisitionReferenceNumber",
                 "identifier" => "acquisition_reference_number",
                 "title" => "acquisition_reference_number",
               },
             },
             "Authorities" => {
              "Person" => ["acquisition_authorizer", "owner"],
            },
            "Relationships" => [
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_1",
                "procedure2_type" => "Acquisition",
                "data2_field" => "acquisition_reference_number",
              },
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_2",
                "procedure2_type" => "Acquisition",
                "data2_field" => "acquisition_reference_number",
              },
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_3",
                "procedure2_type" => "Acquisition",
                "data2_field" => "acquisition_reference_number",
              },
              {
                "procedure1_type" => "Intake",
                "data1_field" => "relationship_4",
                "procedure2_type" => "Acquisition",
                "data2_field" => "acquisition_reference_number",
              },
            ],
          },
          "valuationcontrol" => {
             "Procedures" => {
               "ValuationControl" => {
                 "identifier_field" => "valuationcontrolRefNumber",
                 "identifier" => "valuation_control_reference_number",
                 "title" => "valuation_control_reference_number",
               },
             },
             "Authorities" => {
              "Person" => ["source"],
            },
            "Relationships" => [
              {
                "procedure1_type" => "CollectionObject",
                "data1_field" => "relationship_1",
                "procedure2_type" => "ValuationControl",
                "data2_field" => "valuation_control_reference_number",
              },
            ],
          },
        }
      end

    end
  end
end
