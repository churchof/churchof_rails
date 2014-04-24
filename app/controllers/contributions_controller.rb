class ContributionsController < ApplicationController
  # Show the stripe form.
  def new
    @need = Need.find(params[:need_id])
    @contribution = @need.contributions.build(amount_cents: 1000)
  end

  def create
    @need = Need.find(params[:need_id])
    # if a current user is signed in it will set them as the user for this contribution.
    @contribution = @need.contributions.build(contribution_params.merge(user: current_user))
    @contribution.save
    if @contribution.process_payment
      redirect_to need_path(params[:need_id]), :flash => { :notice => "Payment accepted" }
    else
      redirect_to need_path(params[:need_id]), :error => { :notice => "Your donation was not accepted" }
    end
  end

  private

  def contribution_params
    params.require(:contribution).permit(:amount, :amount_cents, :stripe_token, :stripe_currency, :email)
  end
end
