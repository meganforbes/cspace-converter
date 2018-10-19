class CollectionSpaceObject
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :data_object, counter_cache: true
  validate   :identifier_is_unique_per_type

  after_validation :log_errors, :if => Proc.new { |object| object.errors.any? }

  field :import_batch,     type: String
  field :category,         type: String # Authority, Procedure
  field :type,             type: String
  field :subtype,          type: String # used for Authorities
  field :identifier_field, type: String
  field :identifier,       type: String
  field :title,            type: String
  field :content,          type: String
  # fields from remote collectionspace
  field :csid,             type: String
  field :uri,              type: String

  attr_readonly :type

  scope :transferred, ->{ where(csid: true) } # TODO: check

  def has_csid_and_uri?
    csid and uri
  end

  def is_relationship?
    type == 'Relationship'
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
    identifier = CollectionSpaceObject.where(type: self.type, identifier: self.identifier).count
    if identifier > 1 # don't create another cspace object of same type with the same identifier
      errors.add("Identifier must be unique per type: #{self.type} #{self.identifier}")
    end
  end

  def log_errors
    logger.warn self.errors.full_messages.append([self.attributes.inspect]).join("\n")
  end
end
