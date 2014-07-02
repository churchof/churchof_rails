class OrganizationsController < ApplicationController
  
  load_and_authorize_resource :organization

  def new
    @organization = Organization.new
  end

  def show
    @organization = Organization.find(params[:id])

    needs = Array.new
    users = Array.new

    @organization.organization_roles.each do |organization_role|
      # Get all needs involved in.
      if organization_role.role_type.church_admin?
        if @organization.organization_type.church?
          users << organization_role.user
          organization_role.user.needs_church_admin.public.each do |need|
            needs << need
          end
        end
      end
      if organization_role.role_type.need_leader?
        users << organization_role.user
        organization_role.user.needs_need_leader.public.each do |need|
          needs << need
        end
      end
      if organization_role.role_type.resource_manager?
        users << organization_role.user
      end

    end

    @resources = @organization.resources
    @needs = needs.uniq
    @users = users.uniq

  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      redirect_to root_path, :flash => { :alert => "Organization created." }
    else
      redirect_to root_path, :flash => { :alert => "An error occured." }
    end
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def update
    @organization = Organization.find(params[:id])
    if @organization.update(organization_params)
      redirect_to root_path, :flash => { :alert => "Organization updated." }
    else
      redirect_to root_path, :flash => { :alert => "An error occured." }
    end
  end

  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to root_path, :flash => { :notice => "Organization deleted." } }
      # format.json { head :no_content }
    end
  end


  private

  def organization_params
    params.require(:organization).permit(:title, :description, :address, :organization_type)
  end
end
