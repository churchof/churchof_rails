class ContributorController < ApplicationController

  def new
    @contributor = @contributor.build()
  end

  def create
    @contributor = @contributor.build(contributor_params)
    @contributor.save
    redirect_to root_path
  end

  private

  def contributor_params
    params.require(:contributor).permit(:email, :user_id)
  end

end
