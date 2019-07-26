module CollectionSpace
  module Converter
    module Core
      include Default
      class CoreConditionCheck < ConditionCheck
        def convert
          run do |xml|
              CSXML.add xml, 'conditionCheckRefNumber', attributes.fetch("condition_check_reference_number")
              CSXML.add_group_list xml, 'conditionCheck', [{
                'conditionDate' => attributes['condition date'],
                #last gsub is a hack.  We should probably use the vocab API service
                'condition' => attributes['condition'].downcase.gsub(' ', '_').gsub('/', '_').gsub(/_+/,'_').gsub('not_ex','notex')
              }] if attributes['condition']
              CSXML.add xml, 'conditionChecker', CSURN.get_authority_urn('personauthorities', 'person', attributes["condition_checker"]) if  attributes["condition_checker"]
              CSXML.add xml, 'conditionCheckNote', attributes.fetch("condition_check_note")
            end
        end
      end
    end
  end
end
