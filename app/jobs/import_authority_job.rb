require 'json'

class ImportAuthorityJob < ActiveJob::Base
  queue_as :default

  def perform(config, rows = [])
    batch = Batch.new(
      type: self.class.to_s,
      for: 'authority',
      name: config[:batch],
      status: 'running',
      processed: 0,
      failed: 0,
      start: Time.now,
      end: nil
    )

    batch.processed += 1
    data_object_attributes = {
      converter_profile: 'authority',
      object_data:       {},
      import_batch:      config[:batch],
      import_category:   'Authority',
      import_file:       config[:filename],
    }

    # Authority config
    identifier_field  = config[:id_field]

    rows.each do |data|
      authority_type    = data[:authority_type]
      authority_subtype = data[:authority_subtype]
      unless authority_type && authority_subtype
        logger.warn "Authority Type and SubType are required fields, skipping: #{data}"
        next
      end

      data_object_attributes[:object_data] = data

      begin
        logger.debug "Importing row: #{data_object_attributes.inspect}"
        service = ImportService.new(data_object_attributes)
        service.create_object
        service.add_authority(identifier_field, authority_type, authority_subtype)
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
