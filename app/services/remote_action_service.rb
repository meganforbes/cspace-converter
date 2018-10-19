require 'uri'

class RemoteActionService

  attr_reader :object, :service

  def initialize(object)
    @object = object
    @service = CollectionSpace::Converter::Default.service @object.type, @object.subtype
  end

  def remote_delete
    log.debug("Deleting: #{object.identifier}")
    if @object.uri
      begin
        response = $collectionspace_client.delete(@object.uri)
        if response.status_code.to_s =~ /^2/
          @object.update_attributes!( csid: nil, uri:  nil )
          deleted = true
        end
      rescue Exception => ex
        logger.error("Error during delete: #{@object.inspect}.\n#{ex.backtrace}")
      end
    end
  end

  def remote_transfer
    log.debug("Transferring: #{object.identifier}")
    begin
      blob_uri = @object.data_object.to_hash.fetch('blob_uri', nil)
      if blob_uri.blank? == false
        blob_uri = URI.encode blob_uri
      end
      params   = (blob_uri and @object.type == 'Media') ? { query: { 'blobUri' => blob_uri } } : {}
      response = $collectionspace_client.post(@service[:path], @object.content, params)
      if response.status_code.to_s =~ /^2/
        # http://localhost:1980/cspace-services/collectionobjects/7e5abd18-5aec-4b7f-a10c
        csid = response.headers["Location"].split("/")[-1]
        uri  = "#{@service[:path]}/#{csid}"
        @object.update_attributes!( csid: csid, uri:  uri )
        transferred = true
      end
    rescue Exception => ex
      logger.error("Error during transfer: #{@object.inspect}.\n#{ex.backtrace}")
    end
  end

  def remote_update
    log.debug("Updating: #{object.identifier}")
    if @object.uri
      begin
        response = $collectionspace_client.put(@object.uri, @object.content)
        if response.status_code.to_s =~ /^2/
          updated = true
        end
      rescue Exception => ex
        logger.error("Error during update: #{@object.inspect}\n.#{ex.backtrace}")
      end
    end
    updated
  end

  def remote_already_exists?
    exists      = false
    search_args = {
      path: @service[:path],
      type: "#{@service[:schema]}_common",
      field: @object.identifier_field,
      expression: "= '#{@object.identifier}'",
    }
    message_string = "#{@service[:path]} #{@service[:schema]} #{@object.identifier_field} #{@object.identifier}"

    query    = CollectionSpace::Search.new.from_hash search_args
    response = $collectionspace_client.search(query)
    unless response.status_code.to_s =~ /^2/
      raise "Error searching #{message_string}"
    end
    parsed_response = response.parsed

    # relation list type
    relation  = @service[:path] == "relations" ? true : false
    list_type = @service[:path] == "relations" ? "relations_common_list" : "abstract_common_list"
    list_item = @service[:path] == "relations" ? "relation_list_item" : "list_item"

    # relation search not consistent, skip for now (this means duplication is possible)
    unless relation
      result_count = parsed_response[list_type]["totalItems"].to_i
      if result_count == 1
        exists = true
        # set csid and uri in case they are lost (i.e. batch was deleted)
        @object.update_attributes!(
          csid: parsed_response[list_type][list_item]["csid"],
          uri:  parsed_response[list_type][list_item]["uri"].gsub(/^\//, '')
        )
      else
        raise "Ambiguous result count (#{result_count.to_s}) for #{message_string}" if result_count > 1
        # TODO: set csid and uri to nil if 0?
      end
    end
    exists
  end

end
