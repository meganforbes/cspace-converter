class DataObjectsController < ApplicationController

  def index
    @objects = DataObject.order_by(updated_at: :desc).page params[:page]
  end

  def show
    @object = DataObject.where(id: params[:id]).first
  end

end
