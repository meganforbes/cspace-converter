module CollectionSpace
  module Converter
    module PastPerfect
      include Default

      class PastPerfectValuationControl < ValuationControl

        def convert
          run(wrapper: "document") do |xml|
            xml.send(
              "ns2:valuationcontrols_common",
              "xmlns:ns2" => "http://collectionspace.org/services/valuationcontrol",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              # doing double duty bewtween accessions and objects et al.
              CSXML.add xml, 'valuationcontrolRefNumber', attributes.fetch("accessno", "objectid")
              
              value_source = attributes["appraisor"]
              CSXML::Helpers.add_organization 'valueSource', value_source if value_source
              # CSXML.add 'valueType', attributes[""]

              CSXML.add xml, 'valueNote', attributes["appnotes"]

              # value_date = DateTime.parse(attributes["valuedate"]) rescue nil
              value_date = DateTime.parse(attributes["recdate"]) rescue nil
              CSXML.add xml, 'valueDate', value_date if value_date
            end

            xml.send(
              "ns2:valuationcontrols_bm",
              "xmlns:ns2" => "http://collectionspace.org/services/valuationcontrol/local/bm",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              price = attributes["price"]
              CSXML.add_list xml, 'bmValueAmounts', [{
                "bmValueAmount" => price,
              }] if price
            end

          end
        end

      end

    end
  end
end