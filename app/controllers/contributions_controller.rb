class ContributionsController < ApplicationController
  # Show the stripe form.
  def new
    @need = Need.find(params[:need_id])
    @contribution = @need.contributions.build(cents: 1000)
  end

  def create
    @need = Need.find(params[:need_id])
    # if a current user is signed in it will set them as the user for this contribution.
    @contribution = @need.contributions.build(contribution_params.merge(user: current_user))
    if @contribution.process_payment
      @contribution.save
      redirect_to root_path, :flash => { :notice => "Payment accepted" }
    else
      redirect_to root_path, :error => { :notice => "Your donation was not accepted" }
    end
  end

  private

  def contribution_params
    params.require(:contribution).permit(:cents, :stripe_token, :stripe_currency, :email)
  end
end
