class NeedsController < ApplicationController
  load_and_authorize_resource
  before_action :set_need, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update]

  def set_is_public
    @need = Need.find(params["need"]["id"])
    @need.is_public = params["need"]["is_public"]
    @need.save
    redirect_to root_path
  end

  def create_charge
    # Amount in cents
    @amount = 500

    customer = Stripe::Customer.create(
      :email => current_user.email,
      :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'usd'
    )

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to root_path
  end

  # Part of a workaround for cancan described here: https://github.com/ryanb/cancan/issues/835
  def needs_params
    params.require(:needs).permit(:what, :ever)
  end

  # GET /needs
  # GET /needs.json
  def index
    @needs = Need.where(is_public: true)
    @hash = Gmaps4rails.build_markers(@needs) do |need, marker|
      marker.lat need.latitude
      marker.lng need.longitude
      marker.infowindow need.title
      # marker.picture({
      #   :url    => "http://www.clker.com/cliparts/3/v/I/F/6/V/light-blue-circle-md.png",
      #   :width  => "32",
      #   :height => "32"
      # })
      marker.shadow({
      anchor: [2,22],
      url: '',
      width: 29,
      height: 22 })
      marker.json({ title: need.title })
    end
  end

  # GET /needs/1
  # GET /needs/1.json
  def show
    @expense = Expense.new
  end

  # GET /needs/new
  def new
    @need = Need.new
  end

  # GET /needs/1/edit
  def edit
  end

  # POST /needs
  # POST /needs.json
  def create
    @need = current_user.needs_posted_by.new(need_params)

    respond_to do |format|
      if @need.save
        format.html { redirect_to @need, notice: 'Need was successfully created.' }
        format.json { render action: 'show', status: :created, location: @need }
      else
        format.html { render action: 'new' }
        format.json { render json: @need.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /needs/1
  # PATCH/PUT /needs/1.json
  def update
    respond_to do |format|
      if @need.update(need_params)
        format.html { redirect_to @need, notice: 'Need was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @need.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /needs/1
  # DELETE /needs/1.json
  def destroy
    @need.destroy
    respond_to do |format|
      format.html { redirect_to needs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_need
      @need = Need.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def need_params
      params.require(:need).permit(:id, :full_street_address, :recipient_size, :frequency_type, :recipient_contribution, :date_of_birth, :latitude, :longitude, :leader, :is_public, :first_name, :last_name, :last_four_ssn, :street_address, :drivers_license, :age, :gender, :title_public, :description_public, :need_stage, :title, :description, :user_id_posted_by, :user_id_church_admin)
    end
end
