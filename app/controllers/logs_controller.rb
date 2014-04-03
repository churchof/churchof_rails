class LogsController < ApplicationController
  def create
    logger.debug params['message']
    render :nothing => true
  end
end