require 'json'

class ImportAuthorityJob < ActiveJob::Base
  queue_as :default

  def perform(config, rows = [])
    data_object_attributes = {
      import_type:       'Authority',
      import_file:       config[:filename],
      import_batch:      config[:batch],
      converter_module:  config[:module],
      converter_profile: 'authority',
    }

    # Authority config
    identifier_field  = config[:id_field]
    authority_type    = config[:type]
    authority_subtype = config[:subtype]

    # row_count is used to reference the current row in logging and error messages
    row_count = 1
    rows.each do |data|
      row_count = row_count + 1

      object = DataObject.new.from_json JSON.generate(data)
      object.set_attributes data_object_attributes,row_count
      # validate object immediately after initial attributes set
      object.save!

      # TODO: support for explicit identifiers
      service = CollectionSpace::Converter::Default.service authority_type, authority_subtype
      service_id = service[:id]
      term_display_name = object.read_attribute(identifier_field)
      term_id = object.read_attribute("shortidentifier")
      if term_id == nil
        term_id = AuthCache::lookup_authority_term_id service_id, authority_subtype, term_display_name
      end

      identifier = term_id
      if identifier == nil
        identifier = CSIDF.short_identifier(object.read_attribute(identifier_field))
      end

      if CollectionSpaceObject.has_authority?(identifier)
        cspace_object = CollectionSpaceObject.where(category: 'Authority', identifier: identifier).first
        cspace_object.content = object.to_auth_xml(authority_type, term_display_name, identifier)
        cspace_object.save!
      else
        # CREATE NEW CSPACE OBJECT
        object.add_authority(authority_type, authority_subtype, object.read_attribute(identifier_field), identifier)
        object.save!
      end

    end
  end
end
