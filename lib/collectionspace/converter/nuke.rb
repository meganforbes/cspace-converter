module CollectionSpace
  module Converter
    class Nuke
      def self.everything!
        [DataObject, Delayed::Job].each { |model| model.destroy_all }
      end
    end
  end
end
