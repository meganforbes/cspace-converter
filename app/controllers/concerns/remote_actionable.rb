module RemoteActionable
  extend ActiveSupport::Concern

  def delete
    perform(params[:category]) do |service|
      ok, message = service.remote_delete
      if ok
        flash[:notice] = "Record deleted!"
      else
        flash[:error] = message
      end
    end
  end

  def ping
    perform(params[:category]) do |service|
      if service.remote_already_exists?
        flash[:notice] = "Record found!"
      else
        flash[:warning] = "Record not found!"
      end
    end
  end

  def transfer
    perform(params[:category]) do |service|
      ok, message = service.remote_transfer
      if ok
        flash[:notice] = "Record transferred!"
      else
        flash[:error] = message
      end
    end
  end

  def update
    perform(params[:category]) do |service|
      ok, message = service.remote_update
      if ok
        flash[:notice] = "Record updated!"
      else
        flash[:error] = message
      end
    end
  end

  private

  def perform(category)
    @object  = CollectionSpaceObject.where(category: category).where(id: params[:id]).first
    service  = RemoteActionService.new(@object)

    begin
      yield service
    rescue Exception => ex
      logger.error("Connection error: #{ex.backtrace}")
      flash[:error] = "Connection error: #{ex.message} #{service.inspect}"
    end

    redirect_to send("#{category.downcase}_path".to_sym, @object)
  end
end
