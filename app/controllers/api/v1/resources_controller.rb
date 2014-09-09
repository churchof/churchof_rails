class API::V1::ResourcesController < ApplicationController
	skip_authorization_check
  def index
    @resources = Resource.all
    respond_to do |format|
      format.json do	
			  render :json => custom_json_for(@resources)
			end
    end
  end


  private

	def custom_json_for(value)
	  list = value.map do |resource|
	    { :id => " #{resource.id}",
	      :title => resource.title.to_s,
	      :description => resource.description.to_s
	    }
		end
		list.to_json
	end

end
