class API::V1::ResourcesController < ApplicationController
	skip_authorization_check
  def index
    @resources = Resource.all
    respond_to do |format|
      format.json { render :json => @resources }
    end
  end
end
