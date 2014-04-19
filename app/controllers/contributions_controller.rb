class ContributionsController < ApplicationController
  # Show the stripe form.
  def new
    @need = Need.find(params[:need_id])
    @contribution = @need.contributions.build(amount_cents: 1000)
  end

  def create
    logger.debug "-+-+- 1"
    @need = Need.find(params[:need_id])
        logger.debug "-+-+- 2"
    # if a current user is signed in it will set them as the user for this contribution.
    @contribution = @need.contributions.build(contribution_params.merge(user: current_user))
            logger.debug "-+-+- 3"
    if @contribution.process_payment
                  logger.debug "-+-+- 4"



                  logger.debug @contribution

      @contribution.save
                        logger.debug "-+-+- 5"

      redirect_to root_path, :flash => { :notice => "Payment accepted" }
                              logger.debug "-+-+- 10"

    else
                              logger.debug "-+-+- 6"

      redirect_to root_path, :error => { :notice => "Your donation was not accepted" }
    end
  end

  private

  def contribution_params
    params.require(:contribution).permit(:amount, :amount_cents, :stripe_token, :stripe_currency, :email)
  end
end
