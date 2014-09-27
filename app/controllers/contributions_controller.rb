class ContributionsController < ApplicationController

  load_and_authorize_resource
  

  # Show the stripe form.
  def new
    @need = Need.find(params[:need_id])
    @contribution = @need.contributions.build(amount_cents: 1000)

    @current_active_campaign = nil
    if MatchCampaign.current_active_campaign
      @current_active_campaign = MatchCampaign.current_active_campaign
    end

  end

  def create
    @need = Need.find(params[:need_id])

    # This is here because the ability file solution wasnt working.
    if @need.is_public
        # if a current user is signed in it will set them as the user for this contribution.
        @contribution = @need.contributions.build(contribution_params.merge(user: current_user))
        @contribution.save

        if @contribution.process_payment

          # create_match_contribution_if_available
          if MatchCampaign.current_active_campaign
            if MatchCampaign.current_active_campaign.remaining_amount > Money.new(0, "USD")
              match_contribution = MatchContribution.new()
              if MatchCampaign.current_active_campaign.remaining_amount > @contribution.amount
                match_contribution.amount = @contribution.amount
                match_contribution.is_full_match = true
              else
                match_contribution.amount = MatchCampaign.current_active_campaign.remaining_amount
                match_contribution.is_full_match = false
              end
              match_contribution.contribution_id = @contribution.id
              match_contribution.paid = false
              match_contribution.reimbursed = false
              match_contribution.need_id = @need.id
              match_contribution.match_campaign_id = MatchCampaign.current_active_campaign.id
              match_contribution.save
            end
          end

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
