class CollectionSpaceObject
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :data_object, counter_cache: true
  validate   :identifier_is_unique_per_type

  after_validation :log_errors, :if => Proc.new { |object| object.errors.any? }
  before_validation :set_fingerprint

  field :batch,            type: String
  field :category,         type: String # ex: Authority, Procedure
  field :type,             type: String # ex: CollectionObject, Person
  field :subtype,          type: String # ex: person [auth only]
  field :identifier_field, type: String
  field :identifier,       type: String
  field :title,            type: String
  field :content,          type: String
  field :fingerprint,      type: String
  # fields from remote collectionspace
  field :csid,             type: String
  field :uri,              type: String

  attr_readonly :type

  scope :transferred, ->{ where(csid: true) } # TODO: check

  def has_csid_and_uri?
    !!(csid and uri)
  end

  def is_authority?
    category == 'Authority'
  end

  def is_procedure?
    category == 'Procedure'
  end

  def is_relationship?
    category == 'Relationship'
  end

  def set_fingerprint
    parts = Lookup.category_class(category).parts
    return unless parts.any?
    parts = parts.map { |p| read_attribute(p) }
    write_attribute 'fingerprint', Fingerprint.generate(parts)
  end

  def self.has_authority?(identifier)
    identifier = CollectionSpaceObject.where(category: 'Authority', identifier: identifier).first
    identifier ? true : false
  end

  def self.has_identifier?(identifier)
    identifier = CollectionSpaceObject.where(identifier: identifier).first
    identifier ? true : false
  end

  def self.has_procedure?(identifier)
    identifier = CollectionSpaceObject.where(category: 'Procedure', identifier: identifier).first
    identifier ? true : false
  end

  private

  def identifier_is_unique_per_type
    if CollectionSpaceObject.where(type: type, identifier: identifier).count > 1
      errors.add(:uniqueness, message: "Identifier must be unique per type:#{type};#{identifier}")
    end
  end

  def log_errors
    logger.warn errors.full_messages.append([attributes.inspect]).join("\n")
  end
end
