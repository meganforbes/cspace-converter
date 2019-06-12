module CollectionSpace
  module Converter
    module Core
      include Default

      class CoreAcquisition < Acquisition

        def convert
          run do |xml|
            #acquisitionReferenceNumber
            CSXML.add xml, 'acquisitionReferenceNumber', attributes["acquisition_reference_number"]

            #accessionDateGroup
            CSXML.add_group xml, 'accessionDate', { "dateDisplayDate" => attributes['accession_display_date'],
              'dateEarliestSingleYear' => attributes['accession_earliest_/_single_date_year'],
              'dateEarliestSingleMonth' => attributes['accession_earliest_/_single_date_month'],
              'dateEarliestSingleDay' => attributes['accession_earliest_/_single_date_day'],
              'dateLatestYear' => attributes['accession_latest_date_year'],
              'dateLatestMonth' => attributes['accession_latest_date_month'],
              'dateLatestDay' => attributes['accession_latest_date_day'],
            }

            #acquisitionAuthorizer
            acquisition_authorizer = attributes["acquisition_authorizer"]
            CSXML::Helpers.add_person xml, 'acquisitionAuthorizer', acquisition_authorizer if acquisition_authorizer

            #owner
            CSXML.add_repeat xml, 'owners', [{
              'owner' => CSXML::Helpers.get_authority_urn('personauthorities', 'person', attributes['owner']),
            }] if attributes['owner']

            #acquisitionMethod
            CSXML.add xml, 'acquisition_method', attributes['acquisition_method']

            #acquisitionNote
            CSXML.add xml, 'acquisitionNote', attributes["acquisition_note"]

            #creditLine
            CSXML.add xml, 'creditLine', attributes["credit_line"]

          end
        end

      end

    end
  end
end
