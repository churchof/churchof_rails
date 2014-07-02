class ResourceFlagsController < ApplicationController
  
  load_and_authorize_resource :resource
  load_and_authorize_resource :resource_flag, :through => :resource

  def new
    @resource = Resource.find(params[:resource_id])
    @resource_flag = @resource.resource_flags.new
  end

  def create
    @resource = Resource.find(params[:resource_id])
    @resource_flag = @resource.resource_flags.new(resource_flag_params)
    if @resource_flag.save
      redirect_to root_path, :flash => { :alert => "Resource flag created." }
    else
      redirect_to root_path, :flash => { :alert => "An error occured." }
    end
  end

  def edit
    @resource = Resource.find(params[:resource_id])
    @resource_flag = ResourceFlag.find(params[:id])
  end

  def update
    @resource = Resource.find(params[:resource_id])
    @resource_flag = ResourceFlag.find(params[:id])
    if @resource_flag.update(resource_flag_params)
      redirect_to root_path, :flash => { :alert => "Resource flag updated." }
    else
      redirect_to root_path, :flash => { :alert => "An error occured." }
    end
  end

  private

  def resource_flag_params
    params.require(:resource_flag).permit!
    #params.require(:resource).permit(:title, :description, :website, :contact_phone, :contact_email, :user_id, :organization_id, :availability_status, :status, :address, :latitude, :longitude, :id)
  end
end