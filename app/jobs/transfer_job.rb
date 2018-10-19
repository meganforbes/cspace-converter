class TransferJob < ActiveJob::Base
  queue_as :default

  def perform(action, import_type, import_batch = nil)
    action_method = TransferJob.actions action
    raise "Invalid remote action #{action}!" unless action_method

    CollectionSpaceObject.where(type: import_type, import_batch: import_batch).each do |object|
      service = RemoteActionService.new(object)

      if not object.is_relationship? and not object.has_csid_and_uri?
        service.remote_already_exists? # update csid and uri if object is found
      end

      # UPDATES
      if action_method == :remote_update
        next if object.is_relationship? # not supported
        next if ! object.has_csid_and_uri?
      end

      # TRANSFERS
      if action_method == :remote_transfer
        next if object.has_csid_and_uri? # don't transfer again (use update)
      end

      # DELETES
      if action_method == :remote_delete
        next if ! object.has_csid_and_uri?
      end

      service.send(action_method)
    end
  end

  def self.actions(action)
    {
      "delete" => :remote_delete,
      "remote_delete" => :remote_delete,
      "transfer" => :remote_transfer,
      "remote_transfer" => :remote_transfer,
      "update" => :remote_update,
      "remote_update" => :remote_update,
    }[action]
  end
end
