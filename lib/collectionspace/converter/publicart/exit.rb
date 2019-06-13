module CollectionSpace
  module Converter
    module PublicArt
      include Default

      class PublicArtObjectExit < ObjectExit

        def convert
          run do |xml|
            #exitNumber
            CSXML.add xml, 'exitNumber', attributes["exit_number"]

            #exitDateGroup
            CSXML.add_group xml, 'exitDate', { "dateDisplayDate" => attributes['exit_display_date'],
              'dateEarliestSingleYear' => attributes['exit_earliest_/_single_date_year'],
              'dateEarliestSingleMonth' => attributes['exit_earliest_/_single_date_month'],
              'dateEarliestSingleDay' => attributes['exit_earliest_/_single_date_day'],
              'dateLatestYear' => attributes['exit_latest_date_year'],
              'dateLatestMonth' => attributes['exit_latest_date_month'],
              'dateLatestDay' => attributes['exit_latest_date_day'],
            }

            #currentOwner
            CSXML.add xml, 'currentOwner', CSURN.get_authority_urn('orgauthorities', 'organization', attributes["current_owner"]) if attributes["current_owner"]

            #exitNote
            CSXML.add xml, 'exitNote', attributes["exit_note"]

          end
        end
      end
    end
  end
end
