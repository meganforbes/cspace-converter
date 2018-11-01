module CollectionSpace
  module Converter
    class Fingerprint
      def self.generate(parts)
        Digest::MD5.hexdigest parts.map(&:downcase).join('.')
      end
    end
  end
end
