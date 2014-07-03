class SkillsController < ApplicationController

  # this might not be the safest but it wasnt working with just load and authorize resource: http://stackoverflow.com/questions/19856112/forbiddenattributeserror-in-rails-4
  before_filter :authenticate_user!, :except => [:show, :index]
  load_and_authorize_resource :except => [:show, :index]
  skip_load_resource :only => [:create]

  def index
  logger.debug "This is from debug"

	#@skills = Skill.where(name: params[:q])
  @skills = Skill.where('name ilike ?', '%#{params[:q]}%')
  @skills.each do |skill|
    authorize! :read, skill
  end

	respond_to do |format|
		format.html
		format.json { render :json => @skills.map(&:attributes) }
	end  
  end
  
  def new
    @skill = Skill.new
  end


  def create

    @skill = Skill.new(skills_params)
    if @skill.save
      redirect_to root_path, :flash => { :alert => "Skill created." }
    else
      redirect_to root_path, :flash => { :alert => "An error occured." }
    end
  end

  private

  def skills_params
    params.require(:skill).permit(:name, :description)
  end

end
