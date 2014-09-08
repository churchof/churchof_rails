class API::V1::ResourcesController < ApplicationController
  def index
    @resources = Resource.all
    respond_to do |format|
      format.json { render :json => @resources }
    end
  end
end
