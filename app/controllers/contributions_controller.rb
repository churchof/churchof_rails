# TODO:
#  * capture emails
#  * make contributors
#  * link to user as well
#  * new users should have old contributor records linked
#  * what happens when a user has an account, but isn't logged in when they
#    contribute?
class ContributionsController < ApplicationController
  # Show the stripe form.
  def new
    @need = Need.find(params[:need_id])
    @contribution = @need.contributions.build(cents: 2500)
  end

  def create
    @need = Need.find(params[:need_id])
    @contribution = @need.contributions.build(contribution_params)
    if @contribution.process_payment
      @contribution.save
      flash[:notice] = "Payment accepted"
    else
      flash[:error] = "Your donation was not accepted"
    end
  end

  private

  def contribution_params
    params.require(:contribution).permit(:cents, :stripe_token,
                                         :stripe_currency)
  end
end
