namespace :cache do
  def auth_cache_path
    File.join('data', 'auth_cache', ENV.fetch('CSPACE_CONVERTER_DOMAIN'))
  end

  def auth_cache_vocabularies_file
    File.join(auth_cache_path, 'vocabularies.csv')
  end

  # bundle exec rake cache:clear
  task :clear => :environment do |t, args|
    Rails.cache.clear
  end

  # bundle exec rake cache:setup
  task :setup => :environment do |t, args|
    file = auth_cache_vocabularies_file
    AuthCache::FileLoader.new(file).setup
  end

  # bundle exec rake cache:download_vocabularies
  task :download_vocabularies => :environment do |t, args|
    path = auth_cache_path
    file = auth_cache_vocabularies_file
    FileUtils.mkdir_p path
    FileUtils.rm_f file

    keys = ['refName', 'displayName', 'shortIdentifier']
    CSV.open(file, 'a') do |csv|
      csv << keys
    end


    $collectionspace_client.all('vocabularies').each do |vocab|
      $collectionspace_client.all("#{vocab["uri"]}/items").each do |item|
        Rails.logger.debug item["uri"]
        CSV.open(file, 'a') do |csv|
          csv << item.values_at(*keys)
        end
      end
    end
  end
end
