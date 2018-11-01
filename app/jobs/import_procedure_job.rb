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
      data_object_attributes[:row_count] = row_count
      begin
        logger.debug "Importing row #{row_count}: #{data_object_attributes.inspect}"
        attributes = data_object_attributes.merge(data)

        object = DataObject.new.from_json(JSON.generate(attributes))
        # validate object immediately after initial attributes set
        object.save!

        object.add_procedures
        object.save!

        object.add_authorities
        object.save!

        object.write_attributes(import_status: 0, import_message: 'ok')
        object.save!
      rescue Exception => ex
        logger.error "Failed to import row #{row_count}: #{ex.backtrace}"
        object = DataObject.new.from_json(JSON.generate(data_object_attributes))
        object.write_attributes(import_status: 1, import_message: ex.backtrace)
        object.save!
      end
      row_count += 1
    end
  end
end
