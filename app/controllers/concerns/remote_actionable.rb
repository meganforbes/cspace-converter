module RemoteActionable
  extend ActiveSupport::Concern

  def delete
    perform(:remote_delete, params[:category])
  end

  def ping
    perform(:remote_ping, params[:category])
  end

  def transfer
    perform(:remote_transfer, params[:category])
  end

  def update
    perform(:remote_update, params[:category])
  end

  private

  def flash_type_for_action(ok)
    ok ? :notice : :error
  end

  def perform(action_method, category)
    @object  = CollectionSpaceObject.where(category: category).where(id: params[:id]).first
    service  = RemoteActionService.new(@object)

    begin
      status = service.send(action_method)
      flash[flash_type_for_action(status.ok)] = status.message
    rescue Exception => ex
      logger.error("Connection error:\n#{ex.backtrace}")
      flash[:error] = "Connection error:\n#{ex.message}\n#{ex.backtrace}"
    end

    redirect_to send("#{category.downcase}_path".to_sym, @object)
  end
end
