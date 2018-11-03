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
    authority_type    = config[:type]
    authority_subtype = config[:subtype]

    # row_count is used to reference the current row in logging and error messages
    row_count = 1
    rows.each do |data|
      data_object_attributes[:object_data] = data
      data_object_attributes[:row_count]   = row_count
      logger.debug "Importing row #{row_count}: #{data_object_attributes.inspect}"
      service = ImportService.new(data_object_attributes)
      service.create_object
      service.add_authority(identifier_field, authority_type, authority_subtype)
      row_count += 1
    end
  end
end
