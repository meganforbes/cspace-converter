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
        Rails.logger.debug "Exporting: #{file_path}"
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
        Rails.logger.debug "Processing #{config[:batch]} #{counter}"
        job_class.perform_later(config, chunk)
        # run the job immediately when using rake
        Delayed::Worker.new.run(Delayed::Job.last)
        counter += 1
      end
      Rails.logger.debug "Data import complete. Use db:import:errors task to view any errors."
    end

    # rake db:import:data[data/sample/SampleCatalogingData.csv,cataloging1,Core,cataloging]
    task :data, [:filename, :batch, :module, :profile] => :environment do |t, args|
      config = {
        filename:  args[:filename],
        batch:     args[:batch],
        module:    args[:module],
        profile:   args[:profile],
      }
      unless File.file? config[:filename]
        Rails.logger.error "Invalid file #{config[:filename]}"
        abort
      end
      Rails.logger.debug "Project #{config[:module]}; Batch #{config[:batch]}; Profile #{config[:profile]}"
      process ImportProcedureJob, config
    end

    # rake db:import:errors
    task :errors => :environment do |t, args|
      DataObject.where(import_status: 0).each do |object|
        Rails.logger.info object.inspect
      end
    end

    # rake db:import:authorities[data/sample/SamplePerson.csv,person1,Core,name]
    # rake db:import:authorities[data/sample/SampleMaterial.csv,materials1,Core,materials]
    task :authorities, [:filename, :batch, :module, :id_field] => :environment do |t, args|
      config = {
        filename:   args[:filename],
        batch:      args[:batch],
        module:     args[:module],
        id_field:   args[:id_field],
      }
      unless File.file? config[:filename]
        Rails.logger.error "Invalid file #{config[:filename]}"
        abort
      end
      Rails.logger.debug "Project #{config[:module]}; Batch #{config[:batch]}"
      process ImportAuthorityJob, config
    end
  end

  # rake db:nuke
  task :nuke => :environment do |t|
    CollectionSpace::Converter::Nuke.everything!
    Rails.logger.debug "Database nuked!"
  end
end
