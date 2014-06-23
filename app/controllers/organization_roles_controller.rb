class OrganizationRolesController < ApplicationController
  
  load_and_authorize_resource :organization_role

  def new
    @organization_role = OrganizationRole.new
  end

  def show
    @organization_role = OrganizationRole.find(params[:id])
  end

  def create
    @organization_role = OrganizationRole.new(organization_role_params)
    if @organization_role.save
      redirect_to root_path, :flash => { :alert => "Organization Role created." }
    else
      redirect_to root_path, :flash => { :alert => "An error occured." }
    end
  end

  def edit
    @organization_role = OrganizationRole.find(params[:id])
  end

  def update
    @organization_role = OrganizationRole.find(params[:id])
    if @organization_role.update(organization_role_params)
      redirect_to root_path, :flash => { :alert => "Organization Role updated." }
    else
      redirect_to root_path, :flash => { :alert => "An error occured." }
    end
  end

  def destroy
    @organization_role.destroy
    respond_to do |format|
      format.html { redirect_to root_path, :flash => { :notice => "Organization Role deleted." } }
      # format.json { head :no_content }
    end
  end


  private

  def organization_role_params
    params.require(:organization_role).permit(:user_id, :organization_id, :role_type, :pending)
  end
end
