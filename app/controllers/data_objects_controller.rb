class DataObjectsController < ApplicationController

  def index
    dataset = params[:errors] ? DataObject.where(import_status: 0) : DataObject.all
    @objects = dataset.order_by(updated_at: :desc).page params[:page]
  end

  def show
    @object = DataObject.where(id: params[:id]).first
  end

end
