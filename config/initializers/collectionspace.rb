# Require the DEFAULT module
Dir["#{Rails.root.join('lib', 'collectionspace', 'converter', 'default')}/*.rb"].each do |lib|
  require lib
end

# Require everything else
Dir["#{Rails.root.join('lib', 'collectionspace')}/**/*.rb"].each do |lib|
  require lib
end

unless ENV.fetch('CSPACE_CONVERTER_AUTH_CACHE_INITIALIZE', 'false') == 'false'
  AuthCache::Loader.new.setup
end
