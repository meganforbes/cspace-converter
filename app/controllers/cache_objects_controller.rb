class CacheObjectsController < ApplicationController

  def index
    @objects = CacheObject.all.page params[:page]
  end

end
