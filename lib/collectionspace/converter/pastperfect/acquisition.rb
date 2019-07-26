module CollectionSpace
  module Converter
    module PastPerfect
      include Default
      class PastPerfectAcquisition < Acquisition
        def convert
          run do |xml|
            CSXML.add xml, 'acquisitionReferenceNumber', attributes["accessno"]
            CSXML.add xml, 'acquisitionNote', scrub_fields([ attributes["notes_"], attributes["descrip_"] ])
            # CSXML.add xml, 'acquisitionReason', scrub_fields([ attributes["descrip_"] ])
            CSXML.add xml, 'acquisitionProvisos', attributes["restrict_"]
            CSXML.add xml, 'creditLine', attributes["credit"]

            acquisition_method = attributes["recas"].nil? ?
              nil : CSURN.get_vocab_urn('acquisitionMethod', attributes["recas"])
            CSXML.add xml, 'acquisitionMethod', acquisition_method if acquisition_method

            if attributes.fetch("recfrom", nil)
              acquisition_sources = split_mvf attributes, 'recfrom'
              CSXML::Helpers.add_persons xml, 'acquisitionSource', acquisition_sources, :add_repeat
            end

            acquisition_authorizer = attributes["recby"]
            CSXML::Helpers.add_person xml, 'acquisitionAuthorizer', acquisition_authorizer if acquisition_authorizer

            acquisition_authorizer_date = DateTime.parse(attributes["recdate"]) rescue nil
            CSXML.add xml, 'acquisitionAuthorizerDate', acquisition_authorizer_date if acquisition_authorizer_date

            accession_date = attributes.fetch("accdate", nil)
            CSXML.add_group xml, 'accessionDate', { "dateDisplayDate" => accession_date } if accession_date
          end
        end
      end
    end
  end
end