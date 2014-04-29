class SkillsController < ApplicationController

load_and_authorize_resource
  def index

	# @skills = Skill.where(name: params[:q])
  @skills = Skill.where('name LIKE ?', '%' + params[:q] + '%')

	respond_to do |format|
		format.html
		format.json { render :json => @skills.map(&:attributes) }
	end  
  end
  
  def create
    @need = Need.find(params[:need_id])
    @skill = @need.skills.build(skills_params)
    @skill.save
  end

  private

  def skills_params
    params.require(:skill).permit(:name, :description, :icon_url)
  end

end
