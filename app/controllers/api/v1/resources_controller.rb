class API::V1::ResourcesController < ApplicationController
	skip_authorization_check

	# note the api should have another thing passed in that says the scope... currently index is doing something more specific.
	# also we are letting all this information out freely, should we hold any of it?
  def index
    @resources = Resource.joins(:skills).where("skills.name LIKE ?", "Free Meals").public.uniq

    respond_to do |format|
      format.json do	
			  # render :json => custom_json_for(@resources)
			  render :json => @resources.to_json(:include => [:organization, :resource_events])
			end
    end
  end


  private

  # this might break if there is no organization.
	# def custom_json_for(resources)



	#   resources.each do |resource|

	#   	list <<
	#     { :id => "#{resource.id}",
	#       :title => resource.title.to_s,
	#       :description => resource.description.to_s,
	#       :last_updated => resource.updated_at.to_s,
	#       :contact_phone => resource.contact_phone.to_s,
	#       :availability_status => resource.availability_status.to_s,
	#       :public_status => resource.public_status.to_s,
	#       :latitude => resource.latitude.to_s,
	#       :longitude => resource.longitude.to_s,
	#       :organization_title => resource.organization.title.to_s
	#     }
	# 	end
	# 	list.to_json
	# end

end
