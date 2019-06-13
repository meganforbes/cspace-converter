class ImportService
  attr_reader :data, :object
  def initialize(data)
    @data   = data
    @object = nil
  end

  # "Person" => ["recby", "recfrom"]
  # "Concept" => [ ["objname", "objectname"] ]
  def add_authorities
    raise 'Data Object has not been created' unless object
    authorities = object.profile.fetch("Authorities", {})
    authorities.each do |authority, fields|
      fields.each do |field|
        authority_subtype = authority.downcase

        # if value pair first is the field and second is the specific authority (sub)type
        if field.respond_to? :each
          field, authority_subtype = field
        end

        add_authority(field, authority, authority_subtype, true)
      end
    end
  end

  def add_authority(identifier_field, type, subtype, from_procedure = false)
    term_display_name = object.object_data[identifier_field]
    return unless term_display_name

    service = CollectionSpace::Converter::Default.service type, subtype
    service_id = service[:id]

    # attempt to split field in case it is multi-valued
    term_display_name.split(object.delimiter).map(&:strip).each do |name|
      begin
        identifier = AuthCache::lookup_authority_term_id service_id, subtype, name
        # if we find this procedure authority in the cache skip it!
        next if identifier && from_procedure

        # if the object data contains a shortidentifier then use it, don't generate it
        identifier = object.object_data.fetch("shortidentifier", identifier)
        identifier = CSIDF.short_identifier(name) unless identifier

        unless CollectionSpaceObject.has_authority?(identifier)
          object.add_authority(
            type: type,
            subtype: subtype,
            name: name,
            identifier: identifier,
            from_procedure: from_procedure
          )
          object.save!
        end
      rescue Exception => ex
        logger.error "#{ex.message}\n#{ex.backtrace}"
      end
    end
  end

  # "Acquisition" => { "identifier_field" => "acqid", "identifier" => "acqid", "title" => "acqid" }
  def add_procedures
    raise 'Data Object has not been created' unless object

    procedures = object.profile.fetch("Procedures", {})
    procedures.each do |procedure, attributes|
      begin
        object.add_procedure procedure, attributes
      rescue Exception => ex
        logger.error "#{ex.message}\n#{ex.backtrace}"
      end
    end
  end

  def add_relationships(reciprocal = true)
    relationships = object.profile.fetch("Relationships", [])
    relationships.each do |relationship|
      r  = relationship
      begin
        # no point continuing if the fields don't exist
        unless object.object_data[r["data1_field"]] && object.object_data[r["data2_field"]]
          next
        end

        object.add_relationship r["procedure1_type"], r["data1_field"],
          r["procedure2_type"], r["data2_field"]

        object.add_relationship r["procedure2_type"], r["data2_field"],
          r["procedure1_type"], r["data1_field"] if reciprocal
      rescue Exception => ex
        logger.warn ex.message
      end
    end
  end

  def create_object
    @object = DataObject.new.from_json(JSON.generate(data))
    object.save!
  end

  def update_status(import_status:, import_message:)
    raise 'Data Object has not been created' unless object
    object.write_attributes(
      import_status: import_status,
      import_message: import_message
    )
    object.save!
  end

end
