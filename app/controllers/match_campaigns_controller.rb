class MatchCampaignsController < ApplicationController
  load_and_authorize_resource


  def new
  end

  def create
  	@match_campaign = MatchCampaign.new(match_campaign_params)
    respond_to do |format|
      if @match_campaign.save
        format.html { redirect_to root_path, notice: 'match_campaign was successfully created.' }
        format.json { render action: 'show', status: :created, location: @initiative_metric }
      else
        format.html { render action: 'new' }
        format.json { render json: @match_campaign.errors, status: :unprocessable_entity }
      end
    end

  end

  private

  def match_campaign_params
  	    params.require(:match_campaign).permit!

    #params.require(:match_campaign).permit(:start_date, :end_date, :initial_amount, :initial_amount_cents, :organization_id, :organization)
  end

end
