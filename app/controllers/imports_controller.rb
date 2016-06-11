class ImportsController < ApplicationController

  def new
    #
  end

  def create
    file      = params[:file].path
    batch     = params[:batch]
    converter = params[:converter]
    profile   = params[:profile]

    ::SmarterCSV.process(file, { chunk_size: 100 }) do |chunk|
      ImportJob.perform_later(file, batch, converter, profile, chunk)
    end
    flash[:notice] = "Background import job running. Check back periodically for results."
    redirect_to procedures_path
  end

end
