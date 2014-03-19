class SkillsController < ApplicationController

  def index
	@skills = Skill.where("title like ?", "%#{params[:q]}%")
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
    params.require(:skill).permit(:title, :description, :icon_url)
  end

end
