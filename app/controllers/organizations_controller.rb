class OrganizationsController < ApplicationController
  
  load_and_authorize_resource :organization

  def new
    @organization = Organization.new
  end

  def index
    @organizations = Organization.all.sort_by(&:title)
  end

  def show
    @organization = Organization.find(params[:id])

    needs = Array.new
    users = Array.new
    associated_groups = Array.new

    @organization.organization_roles.each do |organization_role|
      # Get all needs involved in.
      if organization_role.role_type.church_admin?
        if @organization.organization_type.church?
          users << organization_role.user
          organization_role.user.needs_church_admin.public.each do |need|
            needs << need
            if need.user_need_leader
              need.user_need_leader.organization_roles.each do |organization_role|
                if organization_role.organization != @organization
                  associated_groups << organization_role.organization
                end
              end
            end
          end
        end
      end
      if organization_role.role_type.need_leader?
        users << organization_role.user
        organization_role.user.needs_need_leader.public.each do |need|
          needs << need
          if need.user_church_admin
            need.user_church_admin.organization_roles.each do |organization_role|
              # if organization_role.organization != @organization
                associated_groups << organization_role.organization
              # end
            end
          end
        end
      end
      if organization_role.role_type.resource_manager?
        users << organization_role.user
      end

    end

    @resources = @organization.resources
    @needs = needs.uniq.select(&:completion_goal_date).sort_by(&:completion_goal_date) + needs.uniq.reject(&:completion_goal_date)
    @users = users.uniq
    @associated_groups = associated_groups.uniq.sort_by(&:title)

  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      redirect_to organization_resource_validation_partner_panel_index_path, :flash => { :alert => "Organization created." }
    else
      redirect_to organization_resource_validation_partner_panel_index_path, :flash => { :alert => "An error occured." }
    end
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def update
    @organization = Organization.find(params[:id])
    if @organization.update(organization_params)
      redirect_to organization_resource_validation_partner_panel_index_path, :flash => { :alert => "Organization updated." }
    else
      redirect_to organization_resource_validation_partner_panel_index_path, :flash => { :alert => "An error occured." }
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
