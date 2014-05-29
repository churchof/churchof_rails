class TimeContributionsController < ApplicationController
  
  load_and_authorize_resource :need
  load_and_authorize_resource :time_contribution, :through => :need


  # Show the stripe form.
  def new
    @need = Need.find(params[:need_id])
    @time_contribution = @need.time_contributions.build
  end

  def show
    @need = Need.find(params[:need_id])
    @time_contribution = TimeContribution.find(params[:id])
  end


  def create


    if current_user.nil?
  
redirect_to login_path, notice: 'Login or signup in order to volunteer.'
  else

    @need = Need.find(params[:need_id])

# should check in here to make sure one doesnt already exist...
# also needs to go to the login page if nessecary too...

if @need.time_contributions.where(user: current_user).count > 0
        redirect_to root_path, :flash => { :alert => "Already Volunteered" }

else

# should check here that this thing is even taking any volunteers...

        @time_contribution = @need.time_contributions.build(user: current_user, need: @need, cancelled: false)
        @time_contribution.save
        redirect_to need_time_contribution_path(@need, @time_contribution)

end


end

  end

# this could just be destroy, no it should be cancel... and then resign up... meh... ya...
  def edit
    @need = Need.find(params[:need_id])
    @time_contribution = TimeContribution.find(params[:id])
  end



  def update

  if current_user.nil?
  
    redirect_to login_path, notice: 'Login or signup in order to volunteer.'
  else
    @need = Need.find(params[:need_id])
    @time_contribution = @need.time_contributions.find(params[:id])

      if @time_contribution.update(time_contribution_params)
        redirect_to need_time_contribution_path(@need, @time_contribution)
      else
              redirect_to root_path, :flash => { :alert => "Volunteering was not updated." }
      end

    end

  end





  private

  def time_contribution_params
    # this is bad... idk why this wasnt working...
    # no params are working here at all... lots of hack around here to get it working...
    params.require(:time_contribution).permit(:cancelled)
  end
end
