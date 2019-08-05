require 'json'

class ImportProcedureJob < ActiveJob::Base
  queue_as :default

  def perform(config, rows = [])
    batch = Batch.new(
      type: self.class.to_s,
      for: config[:profile],
      name: config[:batch],
      status: 'running',
      processed: 0,
      failed: 0,
      start: Time.now,
      end: nil
    )

    batch.processed += 1
    data_object_attributes = {
      converter_profile: config[:profile],
      object_data:       {},
      import_batch:      config[:batch],
      import_category:   'Procedure',
      import_file:       config[:filename],
    }

    rows.each do |data|
      data_object_attributes[:object_data] = data
      service = ImportService.new(data_object_attributes)
      begin
        logger.debug "Importing row: #{data_object_attributes.inspect}"
        service.create_object
        service.add_procedures
        service.add_authorities
        service.update_status(import_status: 1, import_message: 'ok')
      rescue Exception => ex
        logger.error "Error for import row: #{ex.message}"
        service.update_status(import_status: 0, import_message: ex.message)
        service.object.collection_space_objects.destroy_all
        batch.failed += 1
      end
    end
    batch.status = 'complete'
    batch.end = Time.now
    batch.save
  end
end
