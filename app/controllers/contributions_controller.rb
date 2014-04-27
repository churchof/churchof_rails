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
        if @contribution.process_payment
          if user_signed_in?
              redirect_to contribution_succeeded_path
            else
              redirect_to contribution_succeeded_account_invite_path
          end
        else
          redirect_to contribution_failed_path
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
