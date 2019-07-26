module CollectionSpace
  module Converter
    module Core
      include Default
      class CoreLoanOut < LoanOut
        def convert
          run do |xml|
            CSXML.add xml, 'loanOutNumber', attributes["loan_out_number"]
            CSXML.add xml, 'borrower', CSURN.get_authority_urn('orgauthorities', 'organization', attributes["borrower"])
            CSXML.add xml, 'borrowersAuthorizer', CSURN.get_authority_urn('personauthorities', 'person', attributes["borrower's_authorizer"])
            CSXML.add xml, 'lendersAuthorizer', CSURN.get_authority_urn('personauthorities', 'person', attributes["lender's_authorizer"])
            CSXML.add_group_list xml, 'loanStatus', [{
              "loanStatus" =>  CSURN.get_vocab_urn('loanoutstatus', attributes["loan_status"].capitalize!),
              "loanStatusDate" => attributes["loan_status_date"],
            }] if attributes["loan_status"]
            CSXML.add xml, 'loanOutDate', attributes["loan_out_date"]
            CSXML.add xml, 'loanOutNote', scrub_fields([attributes["loan_out_note"]])
          end
        end
      end
    end
  end
end
