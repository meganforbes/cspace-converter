class BatchesController < ApplicationController

  def index
    @objects = Batch.order_by(start: :desc).page params[:page]
  end

end