class TransferJob < ActiveJob::Base
  queue_as :default

  def perform(action, type, batch = nil)
    action_method = TransferJob.actions action
    raise "Invalid remote action #{action}!" unless action_method

    CollectionSpaceObject.where(type: type, batch: batch).each do |object|
      service = RemoteActionService.new(object)

      if not object.is_relationship? and not object.has_csid_and_uri?
        service.remote_ping # update csid and uri if object is found
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
