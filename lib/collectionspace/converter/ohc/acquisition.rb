module CollectionSpace
  module Converter
    module OHC
      include Default
      class OHCAcquisition < Acquisition
        def convert
          run do |xml|
            CSXML.add xml, 'acquisitionReferenceNumber', attributes['acquisitionreferencenumber']
            CSXML.add xml, 'acquisitionNote', attributes['acquisitionnote']
            CSXML.add xml, 'acquisitionMethod', attributes['acquisitionmethod']

            aa = attributes['acquisitionauthorizer']
            CSXML::Helpers.add_person xml, 'acquisitionAuthorizer', aa if aa

            accdate = CSDTP.parse(attributes['accessiondate']) rescue nil
            CSXML::Helpers.add_date_group xml, 'accessionDate', accdate if accdate

            acqdate = CSDTP.parse(
              attributes['acquisitiondatestart'],
              attributes['acquisitiondateend']
            ) rescue nil
            acqdates = [acqdate].compact
            CSXML::Helpers.add_date_group_list xml, 'acquisitionDate', acqdates if acqdate

            app = [1, 2].map do |i|
              data = {}
              appdate = attributes["approvalstatus#{i}date"]
              data['approvalDate'] = appdate
              if appdate
                data['approvalDate'] = CSDTP.parse(appdate).earliest_scalar
              end
              status = attributes["approvalstatus#{i}status"]
              if status
                status = CSURN.get_vocab_urn('deaccessionapprovalstatus', status, true)
                data['approvalStatus'] = status
              end
              data
            end
            CSXML.add_group_list xml, 'approval', app

            owners = split_mvf(attributes, 'owner_organization').map do |o|
              urn = CSURN.get_authority_urn('orgauthorities', 'organization', o)
              { 'owner' => urn }
            end
            owners.concat(split_mvf(attributes, 'owner_person').map do |o|
              urn = CSURN.get_authority_urn('personauthorities', 'person', o)
              { 'owner' => urn }
            end)
            CSXML.add_repeat xml, 'owners', owners if owners.any?
          end
        end
      end
    end
  end
end
