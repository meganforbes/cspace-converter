namespace :cache do
  def download(path, file, headers, endpoints)
    FileUtils.mkdir_p path
    FileUtils.rm_f file

    CSV.open(file, 'a') do |csv|
      csv << headers
    end

    endpoints.each do |endpoint|
      $collectionspace_client.all(endpoint).each do |list|
        $collectionspace_client.all("#{list["uri"]}/items").each do |item|
          Rails.logger.debug item["uri"]
          CSV.open(file, 'a') do |csv|
            csv << item.values_at(*headers)
          end
        end
      end
    end
  end

  # bundle exec rake cache:clear
  task :clear => :environment do |t, args|
    Rails.cache.clear
  end

  # bundle exec rake cache:download_authorities
  task :download_authorities, [:domain, :module] => :environment do |t, args|
    domain           = args[:domain] ||= ENV.fetch('CSPACE_CONVERTER_DOMAIN')
    converter_module = args[:module] ||= 'core'
    authorities      = Lookup.converter_class(converter_module.capitalize).registered_authorities
    download(
      AuthCache.auth_cache_path(domain),
      AuthCache.auth_cache_authorities_file,
      ['refName', 'termDisplayName', 'shortIdentifier'],
      authorities
    )
  end

  # bundle exec rake cache:download_vocabularies
  task :download_vocabularies, [:domain] => :environment do |t, args|
    domain = args[:domain] ||= ENV.fetch('CSPACE_CONVERTER_DOMAIN')
    download(
      AuthCache.auth_cache_path(domain),
      AuthCache.auth_cache_vocabularies_file,
      ['refName', 'displayName', 'shortIdentifier'],
      ['vocabularies']
    )
  end

  # bundle exec rake cache:setup
  task :setup => :environment do |t, args|
    [AuthCache.auth_cache_authorities_file, AuthCache.auth_cache_vocabularies_file].each do |file|
      AuthCache::FileLoader.new(file).setup
    end
  end
end
