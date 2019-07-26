module CollectionSpace
  module Converter
    module Core
      include Default
      class CoreValuationControl < ValuationControl
        def convert
          run do |xml|
            CSXML.add xml, 'valuationcontrolRefNumber', attributes["valuation_control_reference_number"]
            value_source = attributes["source"]
            CSXML::Helpers.add_persons xml, 'valueSource', [value_source] if value_source
            CSXML.add xml, 'valueNote', attributes["valuation_note"]
            CSXML.add_list xml, 'valueAmounts', [{
              "valueAmount" => attributes['amount'],
              "valueCurrency" => CSURN.get_vocab_urn('currency', attributes['currency']),
            }]
            value_date = DateTime.parse(attributes["date"]) rescue nil
            CSXML.add xml, 'valueDate', value_date if value_date
          end
        end
      end
    end
  end
end
