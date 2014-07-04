class OrganizationsController < ApplicationController
  
  load_and_authorize_resource :organization

  def new
    @organization = Organization.new
  end

  def show
    @organization = Organization.find(params[:id])
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
    params.require(:organization).permit(:title, :description, :address)
  end
end
