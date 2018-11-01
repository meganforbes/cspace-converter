require 'json'

class ImportProcedureJob < ActiveJob::Base
  queue_as :default

  def perform(config, rows = [])
    data_object_attributes = {
      import_type:       'Procedure',
      import_file:       config[:filename],
      import_batch:      config[:batch],
      converter_module:  config[:module],
      converter_profile: config[:profile],
    }

    # row_count is used to reference the current row in logging and error messages
    row_count = 1
    rows.each do |data|
      begin
        row_count = row_count + 1

        object = DataObject.new.from_json JSON.generate(data)
        object.set_attributes data_object_attributes,row_count
        # validate object immediately after initial attributes set
        object.save!

        object.add_procedures
        object.save!

        object.add_authorities
        object.save!
      rescue
        logger.error "Record not staged in Mongo DB. Exception message:#{$!}"
      end
    end
  end
end
