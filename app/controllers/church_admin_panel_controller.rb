class ChurchAdminPanelController < ApplicationController
  def index
  	@needs = Need.all
  end
end
