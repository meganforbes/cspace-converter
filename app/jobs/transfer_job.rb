class TransferJob < ActiveJob::Base
  queue_as :default

  def perform(action, import_type, import_batch = nil)
    action_method = TransferJob.actions action
    raise "Invalid remote action #{action}!" unless action_method

    # cannot lookup relationships so force delete if there is a csid for the object
    is_relationship = import_type == "Relationship" ? true : false
    force_delete    = (is_relationship and action_method == :remote_delete) ? true : false

    CollectionSpaceObject.where(type: import_type, import_batch: import_batch).each do |object|
      service = RemoteActionService.new(object)

      if not is_relationship and not (object.csid and object.uri)
        # ping cspace to see if this object exists remotely
        # this will update local object csid and uri if found
        service.remote_already_exists?
      end
      has_csid_and_uri = (object.csid and object.uri) ? true : false

      already_exists = is_relationship ? false : has_csid_and_uri
      if force_delete or already_exists
        if action_method == :remote_transfer
          # TODO: check we support updates via config
          transferred = service.remote_update
          logger.error "Failed to transfer update #{object.inspect}" unless transferred
        end

        if action_method == :remote_delete
          # relationships can't be confirmed via already exists so make sure there is a csid & uri
          unless has_csid_and_uri
            logger.info "Cannot delete without existing csid and uri for object #{object.inspect}"
            next
          end
          deleted = service.send(action_method)
          logger.error "Failed to delete #{object.inspect}" unless deleted
        end
      else
        if action_method == :remote_transfer
          # skip if there is a csid & uri (relationships cannot be confirmed, others should have been found)
          if has_csid_and_uri
            logger.info "Cannot transfer with existing csid and uri for object #{object.inspect}"
            next
          end
          transferred = service.send(action_method)
          logger.error "Failed to transfer #{object.inspect}" unless transferred
        end

        # if we don't exist and are deleting we don't do anything with :remote_delete =)
      end
    end
  end

  def self.actions(action)
    {
      "delete" => :remote_delete,
      "remote_delete" => :remote_delete,
      "transfer" => :remote_transfer,
      "remote_transfer" => :remote_transfer,
    }[action]
  end
end
