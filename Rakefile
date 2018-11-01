# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

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

namespace :db do
  namespace :export do
    # rake db:export:xml
    task :xml => :environment do |t|
      # mongoid batches by default
      base = ['db', 'data', 'export']
      CollectionSpaceObject.all.each do |obj|
        path = Rails.root.join(File.join(base + [obj.category, obj.type, obj.subtype].compact))
        FileUtils.mkdir_p File.join(path)
        file_path = path + "#{obj.identifier}.xml"
        puts "Exporting: #{file_path}"
        File.open(file_path, 'w') {|f| f.write(obj.content) }
      end
    end
  end

  namespace :import do
    def process(job_class, config)
      counter = 1
      # process in chunks of 100 rows
      SmarterCSV.process(config[:filename], {
          chunk_size: 100,
          convert_values_to_numeric: false,
        }.merge(Rails.application.config.csv_parser_options)) do |chunk|
        puts "Processing #{config[:batch]} #{counter}"
        job_class.perform_later(config, chunk)
        # run the job immediately when using rake
        Delayed::Worker.new.run(Delayed::Job.last)
        counter += 1
      end
    end

    # rake db:import:data[db/data/SampleCatalogingData.csv,cataloging1,Vanilla,cataloging]
    task :data, [:filename, :batch, :module, :profile, :use_auth_cache_file] => :environment do |t, args|
      config = {
        filename:  args[:filename],
        batch:     args[:batch],
        module:    args[:module],
        profile:   args[:profile],
      }
      raise "Invalid file #{config[:filename]}" unless File.file? config[:filename]
      puts "Project #{config[:module]}; Batch #{config[:batch]}; Profile #{config[:profile]}"
      process ImportProcedureJob, config
      puts "Data import complete!"
    end

    # rake db:import:authorities[db/data/SamplePerson.csv,person1,Vanilla,name,Person]
    # rake db:import:authorities[db/data/SampleMaterial.csv,materials1,Vanilla,materials,Concept,materials_ca]
    task :authorities, [:filename, :batch, :module, :id_field, :type, :subtype, :use_auth_cache_file] => :environment do |t, args|
      config = {
        filename:   args[:filename],
        batch:      args[:batch],
        module:     args[:module],
        id_field:   args[:id_field],
        type:       args[:type],
        subtype:    args[:subtype] ||= args[:type].downcase,
      }
      raise "Invalid file #{config[:filename]}" unless File.file? config[:filename]
      puts "Project #{config[:module]}; Batch #{config[:batch]}"
      process ImportAuthorityJob, config
      puts "Data import complete!"
    end
  end

  # rake db:nuke
  task :nuke => :environment do |t|
    Converter::Nuke.everything!
  end
end

namespace :relationships do
  # rake relationships:generate[acq1]
  task :generate, [:batch] => :environment do |t, args|
    batch = args[:batch]

    RelationshipJob.perform_later batch
    # run the job immediately when using rake
    Delayed::Worker.new.run(Delayed::Job.last)

    puts "Relationships created!"
  end
end

namespace :remote do
  namespace :action do

    task :delete, [:type, :batch] => :environment do |t, args|
      type       = args[:type]
      batch      = args[:batch]
      remote_action_process "delete", type, batch
    end

    task :transfer, [:type, :batch] => :environment do |t, args|
      type       = args[:type]
      batch      = args[:batch]
      remote_action_process "transfer", type, batch
    end

    task :update, [:type, :batch] => :environment do |t, args|
      type       = args[:type]
      batch      = args[:batch]
      remote_action_process "update", type, batch
    end

    def remote_action_process(action, type, batch)
      # don't scope to batch if "all" requested
      batch = batch == "all" ? nil : batch
      start_time = Time.now
      puts "Starting remote #{action} job at #{start_time}."
      TransferJob.perform_later(action, type, batch)
      # run the job immediately when using rake
      Delayed::Worker.new.run(Delayed::Job.last)

      end_time = Time.now
      puts "Remote #{action} job completed at #{end_time}."
    end

  end

end
