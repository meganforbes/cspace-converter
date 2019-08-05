module CollectionSpace
  module Converter
    module OHC
      include Default
      class OHCAcquisition < Acquisition
        def convert
          run do |xml|
            CSXML.add xml, 'acquisitionReferenceNumber', attributes['acquisitionreferencenumber']
          end
        end
      end
    end
  end
end
