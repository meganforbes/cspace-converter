namespace :cache do
  # rake cache:from_api
  task :from_api => :environment do |t|
    AuthCache::ApiLoader.new($client).setup
  end

  # rake cache:from_file[file]
  task :from_file, [:file] => :environment do |t, args|
    AuthCache::FileLoader.new(args[:file]).setup
  end
end
