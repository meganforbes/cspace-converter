require 'json'

class ImportProcedureJob < ActiveJob::Base
  queue_as :default

  def perform(config, rows = [])
    data_object_attributes = {
      converter_module:  config[:module],
      converter_profile: config[:profile],
      object_data:       {},
      import_batch:      config[:batch],
      import_category:   'Procedure',
      import_file:       config[:filename],
    }

    # row_count is used to reference the current row in logging and error messages
    row_count = 1
    rows.each do |data|
      data_object_attributes[:object_data] = data
      data_object_attributes[:row_count]   = row_count
      service = ImportService.new(data_object_attributes)
      begin
        logger.debug "Importing row #{row_count}: #{data_object_attributes.inspect}"
        service.create_object
        service.add_procedures
        service.add_authorities
        service.update_status(import_status: 0, import_message: 'ok')
      rescue Exception => ex
        logger.error "Failed to import row #{row_count}: #{ex.backtrace}"
        service.update_status(import_status: 0, import_message: ex.backtrace)
      end
      row_count += 1
    end
  end
end
