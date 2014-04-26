class ContributionsController < ApplicationController

  load_and_authorize_resource
  

  # Show the stripe form.
  def new
    @need = Need.find(params[:need_id])
    @contribution = @need.contributions.build(amount_cents: 1000)
  end

  def create
    @need = Need.find(params[:need_id])

    # This is here because the ability file solution wasnt working.
    if @need.is_public
        # if a current user is signed in it will set them as the user for this contribution.
        @contribution = @need.contributions.build(contribution_params.merge(user: current_user))
        @contribution.save
        if true #@contribution.process_payment
          redirect_to need_path(params[:need_id]), :flash => { :notice => "Payment accepted" }
        else
          redirect_to need_path(params[:need_id]), :error => { :notice => "Your donation was not accepted" }
        end
    else 
      redirect_to root_path, :flash => { :alert => "This need is no longer available to give to." }
    end

  end

  private

  def contribution_params
    params.require(:contribution).permit(:amount, :amount_cents, :stripe_token, :stripe_currency, :email)
  end
end
