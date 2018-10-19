module RemoteActionable
  extend ActiveSupport::Concern

  def delete
    perform(params[:category]) do |service|
      ok, message = service.remote_delete
      flash[flash_type_for_action(ok)] = message
    end
  end

  def ping
    perform(params[:category]) do |service|
      if service.remote_already_exists?
        flash[:notice] = 'Record found!'
      else
        flash[:warning] = "Record not found!"
      end
    end
  end

  def transfer
    perform(params[:category]) do |service|
      ok, message = service.remote_transfer
      flash[flash_type_for_action(ok)] = message
    end
  end

  def update
    perform(params[:category]) do |service|
      ok, message = service.remote_update
      flash[flash_type_for_action(ok)] = message
    end
  end

  private

  def flash_type_for_action(ok)
    ok ? :notice : :error
  end

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
