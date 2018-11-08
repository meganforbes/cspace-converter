module CollectionSpace
  module Converter
    class Task
      ::Task = CollectionSpace::Converter::Task
      def self.generate_content(converter:, object:, data:)
        Rails.logger.debug(
          "Generating content for: #{converter};#{object.inspect};#{data}"
        )

        converter = converter.new(data)

        if converter.respond_to? :term_short_id
          # TODO: get rid of this
          converter.term_short_id=object.identifier
        end

        object.content = hack_namespaces(converter.convert)
        object
      end

      def self.hack_namespaces(xml)
        xml.to_s.gsub(/(<\/?)(\w+_)/, '\1ns2:\2')
      end
    end
  end
end
