require 'json'

class ImportProcedureJob < ActiveJob::Base
  queue_as :default

  def perform(config, rows = [])
    batch = Batch.new(
      type: self.class.to_s,
      name: config[:batch],
      status: 'running',
      processed: 0,
      failed: 0,
      start: Time.now,
      end: nil
    )

    data_object_attributes = {
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
        service.update_status(import_status: 1, import_message: 'ok')
      rescue Exception => ex
        logger.error "Error for import row #{row_count}: #{ex.message}"
        service.update_status(import_status: 0, import_message: ex.message)
        service.object.collection_space_objects.destroy_all
        batch.failed += 1
      end
      batch.processed = row_count
      row_count += 1
    end
    batch.status = 'complete'
    batch.end = Time.now
    batch.save
  end
end
