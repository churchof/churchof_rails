class ResourceEventsController < ApplicationController
  
  load_and_authorize_resource :resource
  load_and_authorize_resource :resource_event, :through => :resource

  def new
    @resource = Resource.find(params[:resource_id])
    @resource_event = @resource.resource_events.new
  end

  def create
    @resource = Resource.find(params[:resource_id])
    @resource_event = @resource.resource_events.new(resource_event_params)
    if @resource_event.save
      redirect_to root_path, :flash => { :alert => "Resource event created." }
    else
      redirect_to root_path, :flash => { :alert => "An error occured." }
    end
  end

  def edit
    @resource = Resource.find(params[:resource_id])
    @resource_event = ResourceEvent.find(params[:id])
  end

  def update
    @resource = Resource.find(params[:resource_id])
    @resource_event = ResourceEvent.find(params[:id])
    if @resource_event.update(resource_event_params)
      redirect_to root_path, :flash => { :alert => "Resource event updated." }
    else
      redirect_to root_path, :flash => { :alert => "An error occured." }
    end
  end

  private

  def resource_event_params
    params.require(:resource_event).permit!
    #params.require(:resource).permit(:title, :description, :website, :contact_phone, :contact_email, :user_id, :organization_id, :availability_status, :status, :address, :latitude, :longitude, :id)
  end
end