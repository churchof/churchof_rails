class UpdatesController < ApplicationController
  before_action :set_update, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource :need
  load_and_authorize_resource :update, :through => :need

  # GET /updates
  # GET /updates.json
  def index
    @need = Need.find(params[:need_id])
    @updates = Update.all
  end

  # GET /updates/1
  # GET /updates/1.json
  def show
    @need = Need.find(params[:need_id])
  end

  # GET /updates/new
  def new
    @need = Need.find(params[:need_id])
    @update = @need.updates.new(update_params)
    @update.images.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @update }
    end
  end

  # GET /updates/1/edit
  def edit
    @need = Need.find(params[:need_id])
  end

  # POST /updates
  # POST /updates.json
  def create
    @need = Need.find(params[:need_id])
    @update = @need.updates.new(update_params)
    respond_to do |format|
      if @update.save
        format.html { redirect_to root_path, notice: 'Update was successfully created.' }
        format.json { render action: 'show', status: :created, location: @update }
      else
        format.html { render action: 'new' }
        format.json { render json: @update.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /updates/1
  # PATCH/PUT /updates/1.json
  def update
    @need = Need.find(params[:need_id])
    respond_to do |format|
      if @update.update(update_params)
        format.html { redirect_to root_path, notice: 'Update was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @update.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /updates/1
  # DELETE /updates/1.json
  def destroy
    @update.destroy
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_update
      @update = Update.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def update_params
      params.require(:update).permit(:need_id, :title, :content)
    end
end
