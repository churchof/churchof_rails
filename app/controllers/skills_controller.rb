class SkillsController < ApplicationController

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
