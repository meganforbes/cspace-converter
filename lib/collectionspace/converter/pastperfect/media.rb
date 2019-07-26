module CollectionSpace
  module Converter
    module PastPerfect
      include Default
      class PastPerfectMedia < Media
        def convert
          run do |xml|
            CSXML.add xml, 'identificationNumber', attributes["objectid"]
            CSXML.add xml, 'title', attributes["imagefile"]
          end
        end
      end
    end
  end
end
