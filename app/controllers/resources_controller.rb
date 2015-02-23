class ResourcesController < ApplicationController
  
  load_and_authorize_resource :resource


  def take_over_management
    @resource = Resource.find(params[:resource][:id])
    @resource.user = current_user
    @resource.save
    redirect_to root_path, :flash => { :alert => "Management taken." }
  end


  def new
    @resource = Resource.new
  end

  def index


    @skills_to_show = Skill.all

    if user_signed_in?
      if current_user.has_role? :church_admin or current_user.has_role? :resource_partner or current_user.has_role? :need_poster or current_user.has_role? :need_leader or current_user.has_role? :organization_resource_validation_partner
        @resources = Resource.all
      else
        @resources = Resource.public
      end
    else
      @resources = Resource.public
    end
 

    if params[:selected_skill].present?
      skill_name = params[:selected_skill]
      @resources = @resources.joins(:skills).where("skills.name LIKE ?", skill_name).uniq
    else
      if params[:selected_initiative].present?
        the_resources = @resources
        @resources = Array.new()
        initiative_name = params[:selected_initiative]
        the_resources.each do |resource|
          resource.skills.each do |skill|
            if skill.initiative
              if skill.initiative.title == initiative_name
                @resources << resource
              end
            end
          end
        end
      end
    end


    if params[:selected_initiative].present? 
      @skills_to_show = Array.new()
      initiative_name = params[:selected_initiative]
      initiative = Initiative.where(title: initiative_name).first
      @skills_to_show = initiative.skills
    end


    if params[:selected_demographic].present?
      demographic_name = params[:selected_demographic]
      the_resources = @resources
      @resources = Array.new()
      the_resources.each do |resource|
        resource.demographics.each do |demographic|
          if demographic.title == demographic_name
            @resources << resource
          end
        end
      end
    end


    if params[:search_value].present?
      search_string = params[:search_value]
      the_resources = @resources
      @resources = Array.new()
      the_resources.each do |resource|
        if resource.title.downcase.include? search_string.downcase
          @resources << resource
        elsif resource.description.downcase.include? search_string.downcase
            @resources << resource   
        elsif resource.organization
          if resource.organization.title.downcase.include? search_string.downcase
            @resources << resource  
          end
        elsif resource.skills.count > 0
          resource.skills.each do |skill|
            if skill.name.downcase.include? search_string.downcase
              @resources << resource
            end
          end
        end
      end
    end

    # The following will make the full list not load on initial load.
    #if not params[:selected_skill].present?
    #  if not params[:selected_initiative].present?
    #    if not params[:selected_demographic].present?
    #      if not params[:search_value].present?
    #        @resources = Array.new()
    #      end
    #    end
    #  end
    #end

    @resources = @resources.uniq

    @users = Hash.new
    if params[:selected_skill].present?
      skill_name = params[:selected_skill]
      skill = Skill.where(name: skill_name).first
      skill.users.each do |user|
        @users[user.id] = user
      end
    end

    @skills_to_show = @skills_to_show.uniq


    @needs_no_organization_category = false
    organizations = Array.new
    @resources.each do |resource|
      if resource.organization
        organizations << resource.organization
      else
        @needs_no_organization_category = true
      end
    end
    @organizations = organizations.uniq.sort_by!{ |m| m.title.downcase }





    @hash = Gmaps4rails.build_markers(@resources) do |resource, marker|
      if resource.latitude
        marker.lat resource.latitude
        marker.lng resource.longitude
      end
      marker.infowindow resource.title

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
      marker.json({ title: resource.title, image_url: resource.skills.first ? resource.skills.first.icon_url : '', custom_infowindow: resource.organization ? "<a href='organizations/#{resource.organization.id}'> #{Sanitize.clean(resource.title)} </a>" : "#{Sanitize.clean(resource.title)}" })
    end


    @organizations = Kaminari.paginate_array(@organizations).page(params[:page]).per(20)


    respond_to do |format|
      format.html
      format.js
    end

  end


  def show
    @resource = Resource.find(params[:id])
  end

  def create
    # @resource = Resource.new(resource_params)
    # if @resource.save
    #   redirect_to root_path, :flash => { :alert => "Resource created." }
    # else
    #   redirect_to root_path, :flash => { :alert => "An error occured." }
    # end


    @resource = Resource.new(resource_params)
    if @resource.save
      redirect_to resource_partner_panel_index_path, :flash => { :alert => "Resource created." }
    else


      redirect_to resource_partner_panel_index_path, :flash => { :alert => @resource.errors.full_messages.to_sentence }
    end

  end

  def edit
    @resource = Resource.find(params[:id])
  end

  def update
    @resource = Resource.find(params[:id])

    if @resource.update(resource_params)
      redirect_to resource_partner_panel_index_path, :flash => { :alert => "Resource updated." }
    else
      redirect_to resource_partner_panel_index_path, :flash => { :alert => "An error occured." }
    end
  end

  def destroy
    @resource.destroy
    respond_to do |format|
      format.html { redirect_to root_path, :flash => { :notice => "Resource deleted." } }
      # format.json { head :no_content }
    end
  end


  private

  def resource_params
# because of nested not figured out, shouldnt be too hard though.
    params.require(:resource).permit!
    #params.require(:resource).permit(:title, :description, :website, :contact_phone, :contact_email, :user_id, :organization_id, :availability_status, :status, :address, :latitude, :longitude, :id)
  end
end
