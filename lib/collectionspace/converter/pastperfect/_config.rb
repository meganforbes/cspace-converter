module CollectionSpace
  module Converter
    module PastPerfect

      def self.registered_procedures
        [
          "Acquisition",
          "CollectionObject",
          "Media",
          "Movement",
          "ValuationControl",
        ]
      end

      def self.registered_profiles
        {
          "accessions" => {
            "Procedures" => {
              "Acquisition" => {
                "identifier_field" => "acquisitionReferenceNumber",
                "identifier" => "accessno",
                "title" => "accessno",
              },
              "ValuationControl" => {
                "identifier_field" => "valuationcontrolRefNumber",
                "identifier" => "accessno",
                "title" => "accessno",
              },
            },
            "Authorities" => {
              "Person" => ["recby", "recfrom"],
            },
            "Relationships" => [
              {
                "procedure1_type"  => "Acquisition",
                "data1_field" => "accessno",
                "procedure2_type"  => "ValuationControl",
                "data2_field" => "accessno",
              },
            ],
          },
          "archives" => {
            "Procedures" => {
              "CollectionObject" => {
                "identifier_field" => "objectNumber",
                "identifier" => "objectid",
                "title" => "title",
              },
              "Movement" => {
                "identifier_field" => "movementReferenceNumber",
                "identifier" => "objectid",
                "title" => "objectid",
              },
            },
            "Authorities" => {
              "Concept" => [["gparent", "category"], ["objname", "objectname"], ["parent", "subcategory"]],
              "Location" => ["location", "permloc"],
              "Organization" => ["publisher"],
              "Person" => ["artist", "artist2", "artist3", "author", "collector", "found", "owned", "phtgrapher", "recby", "recfrom", "used"],
              "Place" => [],
            },
            "Relationships" => [
              {
                "procedure1_type"  => "Acquisition",
                "data1_field" => "accessno",
                "procedure2_type"  => "CollectionObject",
                "data2_field" => "objectid",
              },
              {
                "procedure1_type"  => "CollectionObject",
                "data1_field" => "objectid",
                "procedure2_type"  => "Movement",
                "data2_field" => "objectid",
              },
            ],
          },
          "library" => {
            "Procedures" => {
              "CollectionObject" => {
                "identifier_field" => "objectNumber",
                "identifier" => "objectid",
                "title" => "title",
              },
              "Movement" => {
                "identifier_field" => "movementReferenceNumber",
                "identifier" => "objectid",
                "title" => "objectid",
              },
            },
            "Authorities" => {
              "Concept" => [["gparent", "category"], ["objname", "objectname"], ["parent", "subcategory"]],
              "Location" => ["location", "permloc"],
              "Organization" => ["publisher"],
              "Person" => ["artist", "artist2", "artist3", "author", "collector", "found", "owned", "phtgrapher", "recby", "recfrom", "used"],
              "Place" => [],
            },
            "Relationships" => [
              {
                "procedure1_type"  => "Acquisition",
                "data1_field" => "accessno",
                "procedure2_type"  => "CollectionObject",
                "data2_field" => "objectid",
              },
              {
                "procedure1_type"  => "CollectionObject",
                "data1_field" => "objectid",
                "procedure2_type"  => "Movement",
                "data2_field" => "objectid",
              },
            ],
          },
          "objects" => {
            "Procedures" => {
              "CollectionObject" => {
                "identifier_field" => "objectNumber",
                "identifier" => "objectid",
                "title" => "title",
              },
              "Movement" => {
                "identifier_field" => "movementReferenceNumber",
                "identifier" => "objectid",
                "title" => "objectid",
              },
            },
            "Authorities" => {
              "Concept" => [["gparent", "category"], ["objname", "objectname"], ["parent", "subcategory"]],
              "Location" => ["location", "permloc"],
              "Organization" => ["publisher"],
              "Person" => ["artist", "artist2", "artist3", "author", "collector", "found", "owned", "phtgrapher", "recby", "recfrom", "used"],
              "Place" => [],
            },
            "Relationships" => [
              {
                "procedure1_type"  => "Acquisition",
                "data1_field" => "accessno",
                "procedure2_type"  => "CollectionObject",
                "data2_field" => "objectid",
              },
              {
                "procedure1_type"  => "CollectionObject",
                "data1_field" => "objectid",
                "procedure2_type"  => "Movement",
                "data2_field" => "objectid",
              },
            ],
          },
          "photos" => {
            "Procedures" => {
              "CollectionObject" => {
                "identifier_field" => "objectNumber",
                "identifier" => "objectid",
                "title" => "title",
              },
              "Media" => {
                "identifier_field" => "identificationNumber",
                "identifier" => "objectid",
                "title" => "objectid",
              },
              "Movement" => {
                "identifier_field" => "movementReferenceNumber",
                "identifier" => "objectid",
                "title" => "objectid",
              },
            },
            "Authorities" => {
              "Concept" => [["gparent", "category"], ["objname", "objectname"], ["parent", "subcategory"]],
              "Location" => ["location", "permloc"],
              "Organization" => ["publisher"],
              "Person" => ["artist", "artist2", "artist3", "author", "collector", "found", "owned", "phtgrapher", "recby", "recfrom", "used"],
              "Place" => [],
            },
            "Relationships" => [
              {
                "procedure1_type"  => "Acquisition",
                "data1_field" => "accessno",
                "procedure2_type"  => "CollectionObject",
                "data2_field" => "objectid",
              },
              {
                "procedure1_type"  => "CollectionObject",
                "data1_field" => "objectid",
                "procedure2_type"  => "Media",
                "data2_field" => "objectid",
              },
              {
                "procedure1_type"  => "CollectionObject",
                "data1_field" => "objectid",
                "procedure2_type"  => "Movement",
                "data2_field" => "objectid",
              },
            ],
          },
        }
      end

    end
  end
end