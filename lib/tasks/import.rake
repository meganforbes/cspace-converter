namespace :import do
  def process(job_class, config)
    # process in chunks of 100 rows
    SmarterCSV.process(config[:filename], {
        chunk_size: 100,
        convert_values_to_numeric: false,
      }.merge(Rails.application.config.csv_parser_options)) do |chunk|
      job_class.perform_later(config, chunk)
      # run the job immediately when using rake
      Delayed::Worker.new.run(Delayed::Job.last)
    end
    Rails.logger.debug "Data import complete. Use 'import:errors' task to review any errors."
  end

  # rake import:errors
  task :errors => :environment do |t, args|
    DataObject.where(import_status: 0).each do |object|
      Rails.logger.info object.inspect
    end
  end

  # rake import:procedures[data/sample/core/SampleCatalogingData.csv,cataloging1,cataloging]
  task :procedures, [:filename, :batch, :profile] => :environment do |t, args|
    config = {
      filename:  args[:filename],
      batch:     args[:batch],
      profile:   args[:profile],
    }
    unless File.file? config[:filename]
      Rails.logger.error "Invalid file #{config[:filename]}"
      abort
    end
    Rails.logger.debug "Batch #{config[:batch]}; Profile #{config[:profile]}"
    process ImportProcedureJob, config
  end

  # rake import:authorities[data/sample/core/SamplePerson.csv,person1,name]
  # rake import:authorities[data/sample/core/SampleMaterial.csv,materials1,materials]
  task :authorities, [:filename, :batch, :id_field] => :environment do |t, args|
    config = {
      filename:   args[:filename],
      batch:      args[:batch],
      id_field:   args[:id_field],
    }
    unless File.file? config[:filename]
      Rails.logger.error "Invalid file #{config[:filename]}"
      abort
    end
    Rails.logger.debug "Batch #{config[:batch]}"
    process ImportAuthorityJob, config
  end
end
