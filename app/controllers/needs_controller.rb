class NeedsController < ApplicationController
  load_and_authorize_resource
  before_action :set_need, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update]

  def set_is_public
    @need = Need.find(params["need"]["id"])
    authorize! :set_is_public, @need
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
      if need.shows_real_location_publically
        marker.lat need.latitude
        marker.lng need.longitude
      else
        marker.lat need.approx_latitude
        marker.lng need.approx_longitude
      end
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
      # This should use the path helper.
      marker.json({ title: need.title, image_url: if need.skills.first then need.skills.first.icon_url else '' end, custom_infowindow: "<a href='needs/#{need.id}'> #{need.title_public} </a>" })
    end
  end

  # GET /needs/1
  # GET /needs/1.json
  def show
    @expense = Expense.new
    @needs = Need.where("id like ?", "%#{params[:id]}%")
    @hash = Gmaps4rails.build_markers(@needs) do |need, marker|
      if need.shows_real_location_publically
        marker.lat need.latitude
        marker.lng need.longitude
      else
        marker.lat need.approx_latitude
        marker.lng need.approx_longitude
      end
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

    if params[:add_expense]
      # add empty ingredient associated with @recipe
      @need.expenses.build
    elsif params[:remove_expenses]
      # nested model that have _destroy attribute = 1 automatically deleted by rails
    else
      # save goes like usually
      if @need.save
        flash[:notice] = "Successfully created need."
        redirect_to root_path and return
      end
    end
    render :action => 'new'

    # respond_to do |format|
    #   if @need.save
    #     format.html { redirect_to @need, notice: 'Need was successfully created.' }
    #     format.json { render action: 'show', status: :created, location: @need }
    #   else
    #     format.html { render action: 'new' }
    #     format.json { render json: @need.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /needs/1
  # PATCH/PUT /needs/1.json
  def update


    if params[:add_expense]
      # rebuild the ingredient attributes that doesn't have an id
      unless params[:need][:expenses_attributes].blank?
    for attribute in params[:need][:expenses_attributes]
      @need.expenses.build(attribute.last.except(:_destroy)) unless attribute.last.has_key?(:id)
    end
      end
      # add one more empty ingredient attribute
      @need.expenses.build
    elsif params[:remove_expenses]
      # collect all marked for delete ingredient ids
      removed_expenses = params[:need][:expenses_attributes].collect { |i, att| att[:id] if (att[:id] && att[:_destroy].to_i == 1) }
      # physically delete the ingredients from database
      Expense.delete(removed_expenses)
      flash[:notice] = "Ingredients removed."
      for attribute in params[:need][:expenses_attributes]
        # rebuild ingredients attributes that doesn't have an id and its _destroy attribute is not 1
        @need.expenses.build(attribute.last.except(:_destroy)) if (!attribute.last.has_key?(:id) && attribute.last[:_destroy].to_i == 0)
      end
    else
      # save goes like usual
      if @need.update(need_params)
        flash[:notice] = "Successful updated need."
        redirect_to root_path and return
      end
    end
    render :action => 'edit'


    # respond_to do |format|
    #   if @need.update(need_params)
    #     format.html { redirect_to @need, notice: 'Need was successfully updated.' }
    #     format.json { head :no_content }
    #   else
    #     format.html { render action: 'edit' }
    #     format.json { render json: @need.errors, status: :unprocessable_entity }
    #   end
    # end
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
      params.require(:need).permit! #This is bad... #(:skill_tokens, :shows_real_location_publically, :id, :full_street_address, :recipient_size, :frequency_type, :recipient_contribution, :date_of_birth, :latitude, :longitude, :leader, :is_public, :first_name, :last_name, :last_four_ssn, :street_address, :drivers_license, :age, :gender, :title_public, :description_public, :need_stage, :title, :description, :user_id_posted_by, :user_id_church_admin)
    end
end
