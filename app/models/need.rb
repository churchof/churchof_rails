class Need < ActiveRecord::Base
	extend Enumerize
	resourcify

	enumerize :need_stage, in: {:admin_incoming => 1, :admin_in_progress => 2, :admin_completed => 3, :admin_denied => 4}, default: :admin_incoming
	enumerize :gender, in: {:unknown => 1, :male => 2, :female => 3}
  enumerize :recipient_size, in: {:unknown => 1, :individual => 2, :group => 3}
  enumerize :frequency_type, in: {:unknown => 1, :one_time => 2, :ongoing => 3}

  belongs_to :user_posted_by, :foreign_key => 'user_id_posted_by', :class_name => "User"
  belongs_to :user_church_admin, :foreign_key => 'user_id_church_admin', :class_name => "User"
  belongs_to :user_need_leader, :foreign_key => 'user_id_need_leader', :class_name => "User"

  has_many :contributions
  has_many :time_contributions
  has_many :expenses
  has_many :updates
  has_and_belongs_to_many :skills

	validates :title, presence: true
	validates :title_public, presence: true
	validates :description, presence: true, length: { minimum: 2 }
	validates :description_public, presence: true, length: { minimum: 2 }
	validates :user_id_posted_by, presence: true
	validates :user_id_church_admin, presence: true
  validates :recipient_size, presence: true
  validates :frequency_type, presence: true
  validates :full_street_address, presence: true

	before_save :validate_is_public

  geocoded_by :full_street_address, :if => :full_street_address_changed?   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  before_create :create_approx_location_values
  after_update :update_approx_location_values, :if => :full_street_address_changed?
  after_create :mail_to_church_admin_whos_recieving_the_need, :log_creation
  after_save :mail_to_users_with_relevant_skills

  after_save :mail_to_leader_if_just_appointed

  after_update :mail_to_need_poster_if_just_approved

  after_update :update_date_public_posted_if_changed


  after_create :send_update_to_rosm
  after_update :send_update_to_rosm

  after_update :share_on_social_outlets

  scope :public, -> { where(is_public: true) }
  scope :in_progress, -> { where(need_stage: 2) }
  scope :completed, -> { where(need_stage: 3) }

  def log_creation
    Activity.create(
      subject: self,
      description: 'User created Need.',
      user: self.user_posted_by
    )
  end

  def send_update_to_rosm

    # hit rosm with all appropriate fields
    # only if in production
    # and a try catch


# ONLY IF FOR INDIVIDUAL... AND HAS THOSE FIELDS
    if self.recipient_size.individual?
      begin
        if Rails.env.production?
          require 'net/http'
          if self.rosm_request_id.nil? || self.rosm_request_id == 0
            result = Net::HTTP.get(URI.parse(URI.encode("https://www.rosmky.org/secure/api/api.php?option=writeRequest&FirstName=#{self.first_name.nil? ? "" : self.first_name}&LastName=#{self.last_name.nil? ? "" : self.last_name}&SSN=#{self.last_four_ssn.nil? ? "" : self.last_four_ssn}&Address=#{self.street_address.nil? ? "" : self.street_address}&License=#{self.drivers_license.nil? ? "" : self.drivers_license}&RequestID=#{self.rosm_request_id.nil? ? "" : self.rosm_request_id}&RequestAmount=#{self.total_expenses.nil? ? "" : self.total_expenses}&Church=#{self.user_church_admin.associated_organization.nil? ? "" : self.user_church_admin.associated_organization}&DollarsGiven=#{self.total_contributed.nil? ? "" : self.total_contributed}&Notes=Title:#{self.title_public} - Description:#{self.description_public} - Status:#{self.need_stage} - Church of Lexington Need ID:#{self.id}&Key=#{ENV['ROSM_KEY']}")))
            self.update_column(:rosm_request_id, result)
            # logger.debug "rosmky write WORKED."
            # logger.debug result
            # logger.debug self.rosm_request_id
          else
            result = Net::HTTP.get(URI.parse(URI.encode("https://www.rosmky.org/secure/api/api.php?option=updateRequest&FirstName=#{self.first_name.nil? ? "" : self.first_name}&LastName=#{self.last_name.nil? ? "" : self.last_name}&SSN=#{self.last_four_ssn.nil? ? "" : self.last_four_ssn}&Address=#{self.street_address.nil? ? "" : self.street_address}&License=#{self.drivers_license.nil? ? "" : self.drivers_license}&RequestID=#{self.rosm_request_id.nil? ? "" : self.rosm_request_id}&RequestAmount=#{self.total_expenses.nil? ? "" : self.total_expenses}&Church=#{self.user_church_admin.associated_organization.nil? ? "" : self.user_church_admin.associated_organization}&DollarsGiven=#{self.total_contributed.nil? ? "" : self.total_contributed}&Notes=Title:#{self.title_public} - Description:#{self.description_public} - Status:#{self.need_stage} - Church of Lexington Need ID:#{self.id}&Key=#{ENV['ROSM_KEY']}")))
            self.update_column(:rosm_request_id, result)
            # logger.debug "rosmky write WORKED."
            # logger.debug result
            # logger.debug self.rosm_request_id
          end
        end
      rescue => exception
        logger.debug "rosmky write failed."
        # logger.debug exception
      ensure
      end
    end
    # the returned id should be saved here.
  end

  def mail_to_church_admin_whos_recieving_the_need
    # should this be async?
    Mailer.church_admin_new_need_admin_incoming(self.id, self.user_posted_by.id, self.user_church_admin.id).deliver
  end

  def update_date_public_posted_if_changed
    if self.is_public_changed?
      if self.is_public == true
        self.update_column(:date_public_posted, Time.now)
      end
    end
  end

  def mail_to_leader_if_just_appointed
    if self.user_id_need_leader_changed?
      if self.user_need_leader
        past_relevant_activities = Activity.where(user_id: self.user_need_leader.id, subject: self, description: 'Mailed because new Need pushed to this Leader.')
        if past_relevant_activities.count == 0
          Activity.create!(
            subject: self,
            description: 'Mailed because new Need pushed to this Leader.',
            user_id: self.user_need_leader.id
          )
          Mailer.need_leader_new_need_assigned(self.user_need_leader.id, self.user_church_admin.id, self.id).deliver
        end
      end
    end
  end


  def mail_to_need_poster_if_just_approved
    if (self.need_stage_changed? && self.need_stage == 2)
        # Only email the user if they haven't been emailed about it yet.
        past_relevant_activities = Activity.where(user_id: self.user_posted_by.id, subject: self, description: 'Mailed because need they posted was approved (moved to In Progress).')
        if past_relevant_activities.count == 0
          Activity.create!(
            subject: self,
            description: 'Mailed because need they posted was approved (moved to In Progress).',
            user_id: self.user_posted_by.id
          )
          Mailer.user_posted_by_need_moved_to_in_progress(self.user_posted_by.id, self.id, self.user_church_admin.id).deliver
        end
    end
  end

  accepts_nested_attributes_for :expenses, :allow_destroy => true
  accepts_nested_attributes_for :skills, :allow_destroy => true
  accepts_nested_attributes_for :updates, :allow_destroy => true

  attr_reader :skill_tokens


  def mail_to_users_with_relevant_skills
    if self.is_public
      @users = Hash.new
      self.skills.each do |skill|
        skill.users.each do |user|
          @users[user.id] = user
        end
      end

      @users.each do |_user_id, user|
        past_relevant_activities = Activity.where(user_id: user.id, subject: self, description: 'Mailed about need due to relevant skills.')
        if past_relevant_activities.count == 0
          # Only email the user if they haven't been emailed about it yet.
          Activity.create!( 
            subject: self,
            description: 'Mailed about need due to relevant skills.',
            user_id: user.id
          )
          Mailer.user_new_need_with_matching_skills(user.id, self.id, self.skill_ids).deliver
        end
      end
    end
  end


  def skill_tokens=(ids)
    self.skills.delete_all
    ids.split(",").each do |id|
      self.skills << Skill.find(id)
    end
    self.save
  end

  def create_approx_location_values
    miles = 0.25;
    percent_inner_not_selectable = 40;
    # These calculations will result in roughly this many miles various to the left/right which results not in a circle. The max distance then can be sqrt(miles^2+miles^2).
    # Inner % not an option.
    dither=0.0004 * miles;
    rand1 = rand(100)-50
    rand2 = rand(100)-50
    if rand1 < percent_inner_not_selectable / 2 && rand1 >= 0
      rand1 = percent_inner_not_selectable / 2
    end
    if rand2 > -percent_inner_not_selectable / 2 && rand2 < 0
      rand2 = -percent_inner_not_selectable / 2
    end
    self.approx_latitude = self.latitude + rand1*dither;
    self.approx_longitude = self.longitude + rand2*dither;
  end

  def update_approx_location_values
    miles = 0.25;
    percent_inner_not_selectable = 40;
    # These calculations will result in roughly this many miles various to the left/right which results not in a circle. The max distance then can be sqrt(miles^2+miles^2).
    # Inner % not an option.
    dither=0.0004 * miles;
    rand1 = rand(100)-50
    rand2 = rand(100)-50
    if rand1 < percent_inner_not_selectable / 2 && rand1 >= 0
      rand1 = percent_inner_not_selectable / 2
    end
    if rand2 > -percent_inner_not_selectable / 2 && rand2 < 0
      rand2 = -percent_inner_not_selectable / 2
    end
    self.update_column(:approx_latitude, self.latitude + rand1*dither)
    self.update_column(:approx_longitude, self.longitude + rand2*dither)
  end

  def validate_is_public
    if self.need_stage.admin_incoming?
		  self.is_public = false
   	elsif self.need_stage.admin_denied?
		  self.is_public = false
   	end
   	true
  end

  def skills_count
    self.skills.count
  end

  def total_contributed
    money = Money.new(0, "USD")
    	self.contributions.succeded.not_reimbursed.each do |contribution|
		    money = money + contribution.amount
    	end
    	money
  end

  def total_expenses
    money = Money.new(0, "USD")
    	self.expenses.each do |expense|
		    money = money + expense.amount
    	end
    	money
  end

  def percent_raised
    i = (Float(total_contributed) / Float(total_expenses)) * 100.0
    if i < 0
      i = 0
    end
    if i > 100
      i = 100
    end
    i
  end

  def volunteer_date_passed
    if volunteerTime
      Time.current > volunteerTime
    else
      false
    end
  end

  def time_contribution_for_user(user_id_to_check)
    self.time_contributions.where(user: User.find(user_id_to_check)).first
  end

  def time_contribution_for_user_id(user_id_to_check)
    time_contribution = self.time_contributions.where(user: User.find(user_id_to_check)).first
    time_contribution.id
  end

  def should_accept_volunteers
    # this concept should include only if in progress... and there should also be an equivilant for should take contributions... but the logic right now all rests in each view.
    i = self.volunteersNeededCount.nil? ? 0 : self.volunteersNeededCount
    (i > 0) && !volunteer_date_passed
  end

  def should_accept_contributions
  end

  def total_volunteers
    self.time_contributions.where(cancelled: false).count + (self.additionalVolunteersSignedUpCount.nil? ? 0 : self.additionalVolunteersSignedUpCount)
  end

  def total_needed_volunteers
    self.volunteersNeededCount.nil? ? 0 : self.volunteersNeededCount
  end

  def percent_volunteers_secured
    i = (Float(total_volunteers) / Float(total_needed_volunteers)) * 100.0
    if i < 0
      i = 0
    end
    if i > 100
      i = 100
    end
    i
  end

  def share_on_social_outlets
    return unless Rails.env.production?
    return unless self.is_public_changed?
    return unless self.is_public

    past_relevant_activities = Activity.where(user_id: nil, subject: self, description: 'Social posts for need #{self.id}.')
    if past_relevant_activities.count == 0
      # Only send to Facebook / Twitter once and no times if it fails for some reason.
      Activity.create!(
        subject: self,
        description: 'Social posts for need #{self.id}.',
        user: nil
      )

      begin
        @page = Koala::Facebook::API.new(ENV['FACEBOOK_ACCESS_TOKEN'])
        @page.put_connections(1382913228636299, "feed", :name => self.title_public, :link => "http://church-of.com/needs/#{self.id}", :description => self.description_public, :picture => 'https://s3.amazonaws.com/church_of/assets/ui_assets/icon.png')
      rescue

      end   

      begin
        client = Twitter::REST::Client.new do |config|
          config.consumer_key = ENV['TWITTER_APP_CONSUMER_KEY']
          config.consumer_secret = ENV['TWITTER_APP_CONSUMER_SECRET']
          config.access_token = ENV['TWITTER_USER_ACCESS_TOKEN']
          config.access_token_secret = ENV['TWITTER_USER_ACCESS_SECRET']
        end     
        client.update("#{self.title_public.truncate(113)} - church-of.com/needs/#{self.id}")
      rescue

      end  
      
    end
  end

end
