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




    if user_signed_in?
      if current_user.has_role? :church_admin or current_user.has_role? :resource_partner or current_user.has_role? :need_poster or current_user.has_role? :need_leader or current_user.has_role? :organization_resource_validation_partner
        @resources = Resource.all
      else
        @resources = Resource.public
      end
    else
      @resources = Resource.public
    end
 
    if params[:selected_skills].present?
      skill_name = params[:selected_skills]
      @resources = @resources.joins(:skills).where("skills.name ILIKE ?", skill_name).uniq
    end


    @needs_no_organization_category = false
    organizations = Array.new
    @resources.each do |resource|
      if resource.organization
        organizations << resource.organization
      else
        @needs_no_organization_category = true
      end
    end
    @organizations = organizations.uniq



    respond_to do |format|
      format.html
      format.js
    end

  end


  def show
    @resource = Resource.find(params[:id])
  end

  def create
    # @resource = Resource.new(resource_params)
    # if @resource.save
    #   redirect_to root_path, :flash => { :alert => "Resource created." }
    # else
    #   redirect_to root_path, :flash => { :alert => "An error occured." }
    # end


    @resource = Resource.new(resource_params)
    if @resource.save
      redirect_to resource_partner_panel_index_path, :flash => { :alert => "Resource created." }
    else


      redirect_to resource_partner_panel_index_path, :flash => { :alert => @resource.errors.full_messages.to_sentence }
    end

  end

  def edit
    @resource = Resource.find(params[:id])
  end

  def update
    @resource = Resource.find(params[:id])

    if @resource.update(resource_params)
      redirect_to resource_partner_panel_index_path, :flash => { :alert => "Resource updated." }
    else
      redirect_to resource_partner_panel_index_path, :flash => { :alert => "An error occured." }
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
