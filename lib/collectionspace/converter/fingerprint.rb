module CollectionSpace
  module Converter
    class Fingerprint
      ::Fingerprint = CollectionSpace::Converter::Fingerprint
      def self.generate(parts)
        Digest::MD5.hexdigest parts.map(&:downcase).join('.')
      end
    end
  end
end
