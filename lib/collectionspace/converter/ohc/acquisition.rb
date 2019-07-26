module CollectionSpace
  module Converter
    module OHC
      include Default
      class OHCAcquisition < Acquisition
        def convert
          run do |xml|
            CSXML.add xml, 'acquisitionReferenceNumber', attributes['acquisition_reference_number']
          end
        end
      end
    end
  end
end
