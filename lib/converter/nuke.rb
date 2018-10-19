module Converter

  module Nuke

    def self.everything!
      [DataObject, Delayed::Job].each { |model| model.destroy_all }
    end

  end

end
