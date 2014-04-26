class LogsController < ApplicationController

	skip_authorization_check
  def create
    logger.debug params['message']
    render :nothing => true
  end
end