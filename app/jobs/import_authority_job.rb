require 'json'

class ImportAuthorityJob < ActiveJob::Base
  queue_as :default

  def perform(config, rows = [])
    data_object_attributes = {
      converter_module:  config[:module],
      converter_profile: 'authority',
      object_data:       {},
      import_batch:      config[:batch],
      import_category:   'Authority',
      import_file:       config[:filename],
    }

    # Authority config
    identifier_field  = config[:id_field]

    # row_count is used to reference the current row in logging and error messages
    row_count = 1
    rows.each do |data|
      authority_type    = data[:authority_type]
      authority_subtype = data[:authority_subtype]
      unless authority_type && authority_subtype
        logger.warn "Authority Type and SubType are required fields, skipping: #{data}"
        next
      end

      data_object_attributes[:object_data] = data
      data_object_attributes[:row_count]   = row_count

      begin
        logger.debug "Importing row #{row_count}: #{data_object_attributes.inspect}"
        service = ImportService.new(data_object_attributes)
        service.create_object
        service.add_authority(identifier_field, authority_type, authority_subtype)
        service.update_status(import_status: 0, import_message: 'ok')
      rescue Exception => ex
        logger.error "Failed to import row #{row_count}: #{ex.message}"
        service.update_status(import_status: 0, import_message: ex.message)
      end
      row_count += 1
    end
  end
end
