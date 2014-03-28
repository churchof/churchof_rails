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
    @update = @need.updates.new
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


    if params[:add_image]
      # add empty ingredient associated with @recipe
      @update.images.build
    elsif params[:remove_image]
      # nested model that have _destroy attribute = 1 automatically deleted by rails
    else
      # save goes like usually
      if @update.save
        flash[:notice] = "Successfully created update."
        redirect_to root_path and return
      end
    end
    render :action => 'new'


    # respond_to do |format|
    #   if @update.save
    #     format.html { redirect_to root_path, notice: 'Update was successfully created.' }
    #     format.json { render action: 'show', status: :created, location: @update }
    #   else
    #     format.html { render action: 'new' }
    #     format.json { render json: @update.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /updates/1
  # PATCH/PUT /updates/1.json
  def update





    @need = Need.find(params[:need_id])




    if params[:add_image]
      # rebuild the ingredient attributes that doesn't have an id
      unless params[:update][:images_attributes].blank?
    for attribute in params[:update][:images_attributes]
      @update.images.build(attribute.last.except(:_destroy)) unless attribute.last.has_key?(:id)
    end
      end
      # add one more empty ingredient attribute
      @update.images.build
    elsif params[:remove_image]
      # collect all marked for delete ingredient ids
      removed_images = params[:update][:images_attributes].collect { |i, att| att[:id] if (att[:id] && att[:_destroy].to_i == 1) }
      # physically delete the ingredients from database
      Image.delete(removed_images)
      flash[:notice] = "Ingredients removed."
      for attribute in params[:update][:images_attributes]
        # rebuild ingredients attributes that doesn't have an id and its _destroy attribute is not 1
        @update.images.build(attribute.last.except(:_destroy)) if (!attribute.last.has_key?(:id) && attribute.last[:_destroy].to_i == 0)
      end
    else
      # save goes like usual
      if @update.update(update_params)
        flash[:notice] = "Successful updated need."
        redirect_to root_path and return
      end
    end
    render :action => 'edit'










    # respond_to do |format|
    #   if @update.update(update_params)
    #     format.html { redirect_to root_path, notice: 'Update was successfully updated.' }
    #     format.json { head :no_content }
    #   else
    #     format.html { render action: 'edit' }
    #     format.json { render json: @update.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /updates/1
  # DELETE /updates/1.json
  def destroy
    @update = Recipe.find(params[:id])
    @update.destroy
    flash[:notice] = "Successfully destroyed need."
    redirect_to root_path

    # @update.destroy
    # respond_to do |format|
    #   format.html { redirect_to root_path }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_update
      @update = Update.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def update_params
      params.require(:update).permit! # This is bad... #(:images_attributes, :update, :need_id, :title, :content)
    end
end
