class ChurchAdminPanelController < ApplicationController
  def index
  	@needs_admin_incoming = Need.where(user_church_admin: current_user, need_stage: 1)
  	@needs_admin_in_progress = Need.where(user_church_admin: current_user, need_stage: 2)
  	@needs_admin_completed = Need.where(user_church_admin: current_user, need_stage: 3)
  end
end
