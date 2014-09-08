class API::ResourcesController < ApplicationController
  def index
    @resources = Resource.first
    respond_to do |format|
      format.json { render :json => @resources }
    end
  end
end
