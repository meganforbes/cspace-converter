require 'uri'

class RemoteActionService

  attr_reader :object, :service

  Status = Struct.new(
    :ok,
    :message,
    keyword_init: true
  )

  def initialize(object)
    @object  = object
    @service = CollectionSpace::Converter::Service.lookup object.type, object.subtype
  end

  def remote_delete
    status = Status.new(ok: true, message: '')
    if object.has_csid_and_uri?
      Rails.logger.debug("Deleting: #{object.identifier}")
      begin
        response = $collectionspace_client.delete(object.uri)
        if response.status_code.to_s =~ /^2/
          object.update_attributes!( csid: nil, uri:  nil )
          status.message = "Deleted: #{object.identifier}"
        end
      rescue Exception => ex
        status.ok      = false
        status.message = "Error during delete: #{object.inspect}.\n#{ex.backtrace}"
        Rails.logger.error(status.message)
      end
    else
      status.ok      = false
      status.message = "Delete requires existing csid and uri."
    end
    status
  end

  def remote_transfer
    status = Status.new(ok: true, message: '')
    unless object.has_csid_and_uri?
      Rails.logger.debug("Transferring: #{object.identifier}")
      begin
        blob_uri = object.data_object.object_data.fetch('blob_uri', nil)
        blob_uri = URI.encode blob_uri if !blob_uri.blank?
        params   = (blob_uri && object.type == 'Media') ? { query: { 'blobUri' => blob_uri } } : {}
        response = $collectionspace_client.post(service[:path], object.content, params)
        if response.status_code.to_s =~ /^2/
          # http://localhost:1980/cspace-services/collectionobjects/7e5abd18-5aec-4b7f-a10c
          csid = response.headers["Location"].split("/")[-1]
          uri  = "#{service[:path]}/#{csid}"
          object.update_attributes!( csid: csid, uri:  uri )
          status.message = "Transferred: #{object.identifier}"
        end
      rescue Exception => ex
        status.ok      = false
        status.message = "Error during transfer: #{object.inspect}.\n#{ex.backtrace}"
        Rails.logger.error(status.message)
      end
    else
      status.ok      = false
      status.message = "Transfer requires no pre-existing csid and uri."
    end
    status
  end

  def remote_update
    status = Status.new(ok: true, message: '')
    if object.has_csid_and_uri?
      Rails.logger.debug("Updating: #{object.identifier}")
      begin
        $collectionspace_client.put(object.uri, object.content)
        status.message = "Updated: #{object.identifier}"
      rescue Exception => ex
        status.ok      = false
        status.message = "Error during update: #{object.inspect}.\n#{ex.backtrace}"
        Rails.logger.error(status.message)
      end
    else
      status.ok      = false
      status.message = "Update requires existing csid and uri."
    end
    status
  end

  def remote_ping
    status = Status.new(ok: true, message: '')
    search_args = {
      path: service[:path],
      type: "#{service[:schema]}_common",
      field: object.identifier_field,
      expression: "= '#{object.identifier}'",
    }
    message_string = "#{service[:path]} #{service[:schema]} #{object.identifier_field} #{object.identifier}"

    query    = CollectionSpace::Search.new.from_hash search_args
    response = $collectionspace_client.search(query)
    unless response.status_code.to_s =~ /^2/
      status.ok      = false
      status.message = "Error searching #{message_string}"
      Rails.logger.error(status.message)
      return status
    end
    parsed_response = response.parsed

    # relation list type
    relation  = service[:path] == "relations" ? true : false
    list_type = service[:path] == "relations" ? "relations_common_list" : "abstract_common_list"
    list_item = service[:path] == "relations" ? "relation_list_item" : "list_item"

    return status if relation # cannot reliably search on relations

    result_count = parsed_response[list_type]["totalItems"].to_i
    if result_count == 0
      object.update_attributes!(
        csid: nil,
        uri:  nil
      )
      status.message = 'Record was not found.'
    elsif result_count == 1
      object.update_attributes!(
        csid: parsed_response[list_type][list_item]["csid"],
        uri:  parsed_response[list_type][list_item]["uri"].gsub(/^\//, '')
      )
      status.message = 'Record was found.'
    else
      status.ok      = false
      status.message = "Ambiguous result count (#{result_count}) for #{message_string}"
    end
    status
  end
end
