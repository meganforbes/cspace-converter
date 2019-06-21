namespace :relationships do
  # rake relationships:generate[acq1]
  task :generate, [:batch] => :environment do |t, args|
    batch = args[:batch]

    RelationshipJob.perform_later batch
    # run the job immediately when using rake
    Delayed::Worker.new.run(Delayed::Job.last)

    Rails.logger.debug "Relationships created!"
  end
end
