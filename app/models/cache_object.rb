class CacheObject
  include Mongoid::Document
  validates_uniqueness_of :key

  before_validation :setup

  field :refname,    type: String
  field :name,       type: String
  field :identifier, type: String
  field :type,       type: String
  field :subtype,    type: String
  field :key,        type: String

  def setup
    type    = CSURN.parse_type(refname)
    subtype = CSURN.parse_subtype(refname)
    key     = AuthCache.cache_key([type, subtype, name])
    Rails.logger.info("#{refname}:#{key}")
    write_attribute :type, type
    write_attribute :subtype, subtype
    write_attribute :key, key
  end
end
