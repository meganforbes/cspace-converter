class DataObject
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Attributes::Dynamic

  has_many :collection_space_objects, autosave: true, dependent: :destroy
  validates_presence_of :converter_module
  validates_presence_of :converter_profile
  validates_presence_of :object_data
  validates_presence_of :import_category
  validate :module_and_profile_exist

  field :converter_module,  type: String # ex: Vanilla
  field :converter_profile, type: String # ex: cataloging
  field :object_data,       type: Hash
  field :import_batch,      type: String # ex: cat1
  field :import_file,       type: String # ex: cat1.csv
  field :import_message,    type: String, default: 'ok'
  field :import_status,     type: Integer, default: 1
  field :import_category,   type: String # ex: Procedure
  field :row_count,         type: Integer

  # "Person" => ["recby", "recfrom"]
  # "Concept" => [ ["objname", "objectname"] ]
  def add_authorities
    authorities = self.profile.fetch("Authorities", {})
    authorities_added = Set.new
    authorities.each do |authority, fields|
      fields.each do |field|
        authority_subtype = authority.downcase
        # if value pair first is the field and second is the specific authority (sub)type
        if field.respond_to? :each
          field, authority_subtype = field
        end
        term_display_name = object_data[field]
        next unless term_display_name
        # attempt to split field in case it is multi-valued
        term_display_name.split(self.delimiter).map(&:strip).each do |name|
          begin
            service = CollectionSpace::Converter::Default.service authority, authority_subtype
            service_id = service[:id]
            identifier = AuthCache::lookup_authority_term_id service_id, authority_subtype, name
            # if we find this procedure authority in the cache skip it!
            next if identifier != nil

            identifier = CSIDF.short_identifier(name)

            # pre-filter authorities as we only want to create the first occurrence
            # and not fail CollectionSpaceObject validation for unique_identifier
            next if CollectionSpaceObject.has_authority?(identifier)
            # prevent creation of duplicate authorities between fields in object data
            add_authority(
              type: authority,
              subtype: authority_subtype,
              name: name,
              term_id: nil,
              from_procedure: true
            ) unless authorities_added.include? name
            authorities_added << name
          rescue Exception => ex
            logger.error "#{ex.message}\n#{ex.backtrace}"
          end
        end
      end
    end
  end

  # "Acquisition" => { "identifier_field" => "acqid", "identifier" => "acqid", "title" => "acqid" }
  def add_procedures
    procedures = self.profile.fetch("Procedures", {})
    procedures.each do |procedure, attributes|
      begin
        add_procedure procedure, attributes
      rescue Exception => ex
        logger.error "#{ex.message}\n#{ex.backtrace}"
      end
    end
  end

  # [ { "procedure1_type" => "Acquisition",
  #   "data1_field" => "acquisitionReferenceNumber",
  #   "procedure2_type" => "CollectionObject",
  #   "data2_field" => "objectNumber" } ]
  def add_relationships(reciprocal = true)
    relationships = self.profile.fetch("Relationships", [])
    relationships.each do |relationship|
      r  = relationship
      begin
        # no point continuing if the fields don't exist
        next unless (self.read_attribute(r["data1_field"]) and self.read_attribute(r["data2_field"]))

        add_relationship r["procedure1_type"], r["data1_field"],
          r["procedure2_type"], r["data2_field"]

        add_relationship r["procedure2_type"], r["data2_field"],
          r["procedure1_type"], r["data1_field"] if reciprocal
      rescue Exception => ex
        logger.warn ex.message
      end
    end
  end

  def converter_class
    Lookup.converter_class(converter_module)
  end

  def delimiter
    Rails.application.config.csv_mvf_delimiter
  end

  def profile
    unless @profile
      profiles          = self.converter_class.registered_profiles
      @profile          = profiles[converter_profile]
      if converter_profile != 'authority'
        raise "Invalid profile #{converter_profile} for #{profiles}" unless @profile
      end
    end
    @profile
  end

  def add_authority(type:, subtype:, name:, term_id: nil, from_procedure: false)
    # TODO: check the cache here, remove term_id
    identifier = term_id
    if identifier == nil
      identifier = CSIDF.short_identifier(name)
    end

    converter = nil

    data = {}
    data[:batch]            = import_batch
    data[:category]         = 'Authority' # need this if coming from procedure
    data[:type]             = type
    data[:subtype]          = subtype
    data[:identifier_field] = 'shortIdentifier'
    data[:identifier]       = identifier
    data[:title]            = name

    if from_procedure
      converter = Lookup.default_authority_class(type)
      content_data = {
        "shortIdentifier" => identifier,
        "termDisplayName" => name,
        "termType"        => "#{CSIDF.authority_term_type(type)}Term",
      }
    else
      converter    = Lookup.authority_class(converter_module, type)
      content_data = object_data
    end

    cspace_object = collection_space_objects.build(data)
    Task.generate_content(
      converter: converter,
      data: content_data,
      object: cspace_object,
    )
  end

  def add_procedure(procedure, attributes)
    converter = Lookup.procedure_class(converter_module, procedure)

    data = {}
    data[:batch]            = self.import_batch
    data[:category]         = 'Procedure'
    data[:type]             = procedure
    data[:subtype]          = ''
    data[:identifier_field] = attributes["identifier_field"]
    data[:identifier]       = object_data[attributes["identifier"]]
    data[:title]            = self.read_attribute( attributes["title"] )

    cspace_object = collection_space_objects.build(data)
    Task.generate_content(
      converter: converter,
      data: object_data,
      object: cspace_object,
    )
  end

  def add_relationship(from_procedure, from_field, to_procedure, to_field)
    from_value = self.read_attribute( from_field )
    to_value   = self.read_attribute( to_field )
    raise "No data for field pair [#{from_field}:#{to_field}] for #{self.id}" unless (from_value and to_value)

    # TODO: update this (lookup doc_type)!
    from_doc_type = "#{from_procedure.downcase}s"
    from          = CollectionSpaceObject.where(type: from_procedure, identifier: from_value).first
    to_doc_type   = "#{to_procedure.downcase}s"
    to            = CollectionSpaceObject.where(type: to_procedure, identifier: to_value).first
    raise "Object pair not found [#{from_value}:#{to_value}] for #{self.id}" unless (from and to)

    from_csid = from.read_attribute "csid"
    to_csid   = to.read_attribute   "csid"
    unless (from_csid and to_csid)
      raise "CSID values not found for pair [#{from.identifier}:#{to.identifier}] for #{self.id}"
    end

    attributes = {
      "from_csid" => from_csid,
      "from_doc_type" => from_doc_type,
      "to_csid" => to_csid,
      "to_doc_type" => to_doc_type,
    }

    from_prefix = from_doc_type[0..2]
    to_prefix   = to_doc_type[0..2]

    converter = Lookup.default_relationship_class

    data = {}
    data[:batch]            = import_batch
    data[:category]         = "Relationship"
    data[:type]             = "Relationship"
    data[:subtype]             = ""
    # this will allow remote actions to happen (but not prevent duplicates?)
    data[:identifier_field] = 'csid'
    data[:identifier]       = "#{from_csid}_#{to_csid}"
    data[:title]            = "#{from_prefix}:#{from_value}_#{to_prefix}:#{to_value}"
    self.collection_space_objects.build data

    cspace_object = collection_space_objects.build(data)
    Task.generate_content(
      converter: converter,
      data: attributes,
      object: cspace_object,
    )
  end

  def module_and_profile_exist
    begin
      self.profile
    rescue Exception => ex
      errors.add(:invalid_module_or_profile, ex.message)
    end
  end

end
