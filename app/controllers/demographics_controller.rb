class DemographicsController < ApplicationController
  load_and_authorize_resource
  before_action :set_demographic, only: [:show, :edit, :update, :destroy]

  # GET /initiatives
  # GET /initiatives.json
  def index
    @demographics = Demographic.all
  end

  # GET /initiatives/1
  # GET /initiatives/1.json
  def show
  end

  # GET /initiatives/new
  def new
    @demographic = Demographic.new
  end

  # GET /initiatives/1/edit
  def edit
  end

  # POST /initiatives
  # POST /initiatives.json
  def create
    @demographic = Demographic.new(demographic_params)

    respond_to do |format|
      if @demographic.save
        format.html { redirect_to @demographic, notice: 'Demographic was successfully created.' }
        format.json { render action: 'show', status: :created, location: @demographic }
      else
        format.html { render action: 'new' }
        format.json { render json: @demographic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /initiatives/1
  # PATCH/PUT /initiatives/1.json
  def update
    respond_to do |format|
      if @demographic.update(demographic_params)
        format.html { redirect_to @demographic, notice: 'Demographic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @demographic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /initiatives/1
  # DELETE /initiatives/1.json
  def destroy
    @demographic.destroy
    respond_to do |format|
      format.html { redirect_to demographics_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_demographic
      @demographic = Demographic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def demographic_params
      params.require(:demographic).permit(:title)
    end
end
