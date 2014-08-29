class InitiativeMetricsController < ApplicationController
  load_and_authorize_resource
  before_action :set_initiative, only: [:new, :edit, :create, :index]
  before_action :set_initiative_metric, only: [:show, :edit, :update, :destroy]

  # GET /initiative_metrics
  # GET /initiative_metrics.json
  def index
    @initiative_metrics = InitiativeMetric.all
  end

  # GET /initiative_metrics/1
  # GET /initiative_metrics/1.json
  def show
  end

  # GET /initiative_metrics/new
  def new
    @initiative_metric = @initiative.initiative_metrics.new
  end

  # GET /initiative_metrics/1/edit
  def edit
  end

  # POST /initiative_metrics
  # POST /initiative_metrics.json
  def create
    @initiative_metric = @initiative.initiative_metrics.new(initiative_metric_params)

    respond_to do |format|
      if @initiative_metric.save
        format.html { redirect_to [@initiative, @initiative_metric], notice: 'Initiative metric was successfully created.' }
        format.json { render action: 'show', status: :created, location: @initiative_metric }
      else
        format.html { render action: 'new' }
        format.json { render json: [@initiative, @initiative_metric].errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /initiative_metrics/1
  # PATCH/PUT /initiative_metrics/1.json
  def update
    respond_to do |format|
      if @initiative_metric.update(initiative_metric_params)
        format.html { redirect_to [@initiative_metric.initiative, @initiative_metric], notice: 'Initiative metric was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: [@initiative_metric.initiative, @initiative_metric].errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /initiative_metrics/1
  # DELETE /initiative_metrics/1.json
  def destroy
    @initiative_metric.destroy
    respond_to do |format|
      format.html { redirect_to initiative_initiative_metrics_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_initiative
      @initiative = Initiative.find(params[:initiative_id])
    end

    def set_initiative_metric
      @initiative_metric = InitiativeMetric.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def initiative_metric_params
      params.require(:initiative_metric).permit(:title)
    end
end
