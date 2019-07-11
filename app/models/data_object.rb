class DataObject
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :collection_space_objects, autosave: true, dependent: :destroy
  validates_presence_of :converter_module
  validates_presence_of :converter_profile
  validates_presence_of :object_data
  validates_presence_of :import_category
  validate :module_and_profile_exist

  before_validation :set_module

  field :converter_module,  type: String # ex: Core
  field :converter_profile, type: String # ex: cataloging
  field :object_data,       type: Hash
  field :import_batch,      type: String # ex: cat1
  field :import_file,       type: String # ex: cat1.csv
  field :import_message,    type: String, default: 'ok'
  field :import_status,     type: Integer, default: 1
  field :import_category,   type: String # ex: Procedure
  field :row_count,         type: Integer

  def converter_class
    Lookup.converter_class
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

  def set_module
    write_attribute :converter_module, ENV.fetch('CSPACE_CONVERTER_MODULE').capitalize
  end

  def add_authority(type:, subtype:, name:, identifier: nil, from_procedure: false)
    # TODO: check the cache here, remove term_id
    identifier ||= CSIDF.short_identifier(name)

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
      converter    = Lookup.authority_class(type)
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
    converter = Lookup.procedure_class(procedure)

    data = {}
    data[:batch]            = import_batch
    data[:category]         = 'Procedure'
    data[:type]             = procedure
    data[:subtype]          = ''
    data[:identifier_field] = attributes["identifier_field"]
    data[:identifier]       = object_data[attributes["identifier"]]
    data[:title]            = object_data[attributes["title"]]

    cspace_object = collection_space_objects.build(data)
    Task.generate_content(
      converter: converter,
      data: object_data,
      object: cspace_object,
    )
  end

  def add_relationship(from_procedure, from_field, to_procedure, to_field)
    from_value = object_data[from_field]
    to_value   = object_data[to_field]
    unless (from_value and to_value)
      raise "No data for field pair [#{from_field}:#{to_field}] for #{id}"
    end

    # TODO: update this (lookup doc_type)!
    from_doc_type = "#{from_procedure.downcase}s"
    from = CollectionSpaceObject.where(
      type: from_procedure,
      identifier: from_value
    ).first

    to_doc_type = "#{to_procedure.downcase}s"
    to = CollectionSpaceObject.where(
      type: to_procedure,
      identifier: to_value
    ).first

    raise "Object pair not found [#{from_value}:#{to_value}] for #{id}" unless (from and to)

    from_csid = from.csid
    to_csid   = to.csid
    unless (from_csid and to_csid)
      raise "CSID values not found for pair [#{from.id}:#{to.id}] for #{id}"
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
