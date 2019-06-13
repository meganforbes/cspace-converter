module CollectionSpace
  module Converter
    module PublicArt
      include Default

      class PublicArtLoanOut < LoanOut

        def convert
          run do |xml|
            #loanOutNumber
            CSXML.add xml, 'loanOutNumber', attributes["loan_out_number"]

            #borrower
            CSXML.add xml, 'borrower', CSXML::Helpers.get_authority_urn('orgauthorities', 'organization', attributes["borrower"])

            #borrowersAuthorizer
            CSXML.add xml, 'borrowersAuthorizer', CSXML::Helpers.get_authority_urn('personauthorities', 'person', attributes["borrower's_authorizer"])

            #lendersAuthorizer
            CSXML.add xml, 'lendersAuthorizer', CSXML::Helpers.get_authority_urn('personauthorities', 'person', attributes["lender's_authorizer"])

            #loanStatusGroupList
            CSXML.add_group_list xml, 'loanStatus', [{
              "loanStatus" =>  CSXML::Helpers.get_vocab_urn('loanoutstatus', attributes["loan_status"].capitalize!),
              "loanStatusDate" => attributes["loan_status_date"],
            }] if attributes["loan_status"]

            #loanOutDate
            CSXML.add xml, 'loanOutDate', attributes["loan_out_date"]

            #loanOutNote
            CSXML.add xml, 'loanOutNote', scrub_fields([attributes["loan_out_note"]])

          end
        end

      end

    end
  end
end
