namespace :remote do
  task :delete, [:type, :batch] => :environment do |t, args|
    type       = args[:type]
    batch      = args[:batch]
    remote_action_process "delete", type, batch
  end

  task :get, [:path] => :environment do |t, args|
    path = args[:path]
    puts $collectionspace_client.get(path).xml
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
    Rails.logger.debug "Starting remote #{action} job at #{start_time}."
    TransferJob.perform_later(action, type, batch)
    # run the job immediately when using rake
    Delayed::Worker.new.run(Delayed::Job.last)

    end_time = Time.now
    Rails.logger.debug "Remote #{action} job completed at #{end_time}."
  end
end
