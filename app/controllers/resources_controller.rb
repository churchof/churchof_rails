class ResourcesController < ApplicationController
  
  load_and_authorize_resource :resource


  def take_over_management
    @resource = Resource.find(params[:resource][:id])
    @resource.user = current_user
    @resource.save
    redirect_to root_path, :flash => { :alert => "Management taken." }
  end


  def new
    @resource = Resource.new
  end

  def index
    @resources = Resource.all
    @organizations = Organization.all
  end


  def show
    @resource = Resource.find(params[:id])
  end

  def create
    @resource = Resource.new(resource_params)
    if @resource.save
      redirect_to root_path, :flash => { :alert => "Resource created." }
    else
      redirect_to root_path, :flash => { :alert => "An error occured." }
    end
  end

  def edit
    @resource = Resource.find(params[:id])
  end

  def update
    @resource = Resource.find(params[:id])
    if @resource.update(resource_params)
      redirect_to root_path, :flash => { :alert => "Resource updated." }
    else
      redirect_to root_path, :flash => { :alert => "An error occured." }
    end
  end

  def destroy
    @resource.destroy
    respond_to do |format|
      format.html { redirect_to root_path, :flash => { :notice => "Resource deleted." } }
      # format.json { head :no_content }
    end
  end


  private

  def resource_params
# because of nested not figured out, shouldnt be too hard though.
    params.require(:resource).permit!
    #params.require(:resource).permit(:title, :description, :website, :contact_phone, :contact_email, :user_id, :organization_id, :availability_status, :status, :address, :latitude, :longitude, :id)
  end
end
