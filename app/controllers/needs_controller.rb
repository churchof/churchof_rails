class NeedsController < ApplicationController
  load_and_authorize_resource
  before_action :set_need, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]

  def set_is_public
    @need = Need.find(params["need"]["id"])
    authorize! :set_is_public, @need
    # Should only be able to set if its in progress so the archived version stays the same.
    if @need.need_stage_value == 2
      if params["need"]["is_public"] == "false"
        if @need.contributions.succeded.not_reimbursed.count == 0
          @need.is_public = params["need"]["is_public"]
          @need.save


          redirect_to "/church_admin_panel/index?selected=admin_in_progress", notice: 'Need was successfully updated.'
        else
          redirect_to "/church_admin_panel/index?selected=admin_in_progress", alert: 'Need was not updated because people have already given to it.'
        end
      else
        @need.is_public = params["need"]["is_public"]
        @need.save
        #
          redirect_to "/church_admin_panel/index?selected=admin_in_progress", notice: 'Need was successfully updated.'
      end
    end
  end

  # def record_usage
  #   logger.debug "Would record that activity here"
  # end

  # def filtered
  #   puts "Hello Mel"
  #   respond_to :js
  # end

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

  # GET /needs
  # GET /needs.json
  def index
    if params[:selected_skills].present?
      skill_name = params[:selected_skills]
      @needs = Need.public.in_progress.joins(:skills).where("skills.name ILIKE ?", skill_name).uniq.reverse
    else
      @needs = Need.public.in_progress.reverse
    end

    @skills = Skill.all

    skills_represented = Array.new
    @needs.each do |need|

      need.skills.each do |skill|
        skills_represented << skill
      end
      
    end
    @skills_represented = skills_represented.uniq

    
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
      marker.json({ title: need.title, image_url: need.skills.first ? need.skills.first.icon_url : '', custom_infowindow: "<a href='needs/#{need.id}'> #{Sanitize.clean(need.title_public)} </a>" })
    end

    # respond_to :html, :js

    respond_to do |format|
      format.html
      format.js
  end

  end

  # GET /needs/1
  # GET /needs/1.json
  def show
    @expense = Expense.new
    @needs = Need.where(id: params[:id])
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
      marker.json({ title: need.title, image_url: if need.skills.first then need.skills.first.icon_url else '' end})
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

    respond_to do |format|
      if @need.save
        format.html { redirect_to @need, notice: 'Need was successfully created.' }
        # format.json { render action: 'show', status: :created, location: @need }
      else
        format.html { render action: 'new' }
        # format.json { render json: @need.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /needs/1
  # PATCH/PUT /needs/1.json
  def update
    respond_to do |format|
      if @need.update(need_params)
        format.html { redirect_to @need, notice: 'Need was successfully updated.' }
        # format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        # format.json { render json: @need.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /needs/1
  # DELETE /needs/1.json
  def destroy
    @need.destroy
    respond_to do |format|
      format.html { redirect_to needs_url }
      # format.json { head :no_content }
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
