namespace :cache do
  def download(headers, endpoints)
    endpoints.each do |endpoint|
      $collectionspace_client.all(endpoint).each do |list|
        $collectionspace_client.all("#{list["uri"]}/items").each do |item|
          Rails.logger.debug item["uri"]
          refname, name, identifier = item.values_at(*headers)
          CacheObject.create(
            refname: refname,
            name: name,
            identifier: identifier
          )
        end
      end
    end
  end

  # bundle exec rake cache:clear
  task :clear => :environment do |t, args|
    Rails.cache.clear
  end

  # bundle exec rake cache:download_authorities
  task :download_authorities => :environment do |t, args|
    authorities = Lookup.converter_class.registered_authorities
    download(
      ['refName', 'termDisplayName', 'shortIdentifier'],
      authorities
    )
  end

  # bundle exec rake cache:download_vocabularies
  task :download_vocabularies => :environment do |t, args|
    download(
      ['refName', 'displayName', 'shortIdentifier'],
      ['vocabularies']
    )
  end

  # task :export [to csv]
  # task :import [from csv]

  # bundle exec rake cache:setup
  task :setup => :environment do |t, args|
    AuthCache::Loader.new.setup
  end
end
