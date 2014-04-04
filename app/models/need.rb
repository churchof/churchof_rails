class Need < ActiveRecord::Base
	extend Enumerize
	resourcify

	enumerize :need_stage, in: {:admin_incoming => 1, :admin_in_progress => 2, :admin_completed => 3}, default: :admin_incoming
	enumerize :gender, in: {:unknown => 1, :male => 2, :female => 3}
  enumerize :recipient_size, in: {:unknown => 1, :individual => 2, :group => 3}
  enumerize :frequency_type, in: {:unknown => 1, :one_time => 2, :ongoing => 3}

  belongs_to :user_posted_by, :foreign_key => 'user_id_posted_by', :class_name => "User"
  belongs_to :user_church_admin, :foreign_key => 'user_id_church_admin', :class_name => "User"
  	
  has_many :contributions
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
	
  geocoded_by :full_street_address   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  before_create :create_approx_location_values
  after_create :mail_to_church_admin_whos_recieving_the_need
  after_save :mail_to_users_with_relevant_skills

  after_update :mail_to_need_poster_if_just_approved

  def mail_to_church_admin_whos_recieving_the_need
    # should this be async?
    Mailer.church_admin_new_need_admin_incoming(self, self.user_posted_by, self.user_church_admin).deliver
  end


  def mail_to_need_poster_if_just_approved
    if (self.need_stage_changed? && self.need_stage == 2)
        # Only email the user if they haven't been emailed about it yet.
        past_relevant_activities = Activity.where(user_id: self.user_posted_by.id, subject: self, description: 'Mailed because need they posted was approved (moved to In Progress).')
        if past_relevant_activities.count == 0
          Mailer.user_posted_by_need_moved_to_in_progress(self.user_posted_by, self, self.user_church_admin).deliver
          Activity.create(
            subject: self,
            description: 'Mailed because need they posted was approved (moved to In Progress).',
            user: self.user_posted_by
          )
        end
    end
  end



  accepts_nested_attributes_for :expenses, :allow_destroy => true
  accepts_nested_attributes_for :skills, :allow_destroy => true

  attr_reader :skill_tokens


  def mail_to_users_with_relevant_skills

    # should this be async?
    # this needs to be after its set public... also should keep a record of who its sent to really...
    if self.is_public
      @users = Array.new
      self.skills.each do |skill|
        skill.users.each do |user|
          @users << user
        end
      end
      @users.uniq.each do |user|
        past_relevant_activities = Activity.where(user_id: user.id, subject: self, description: 'Mailed about need due to relevant skills.')
        if past_relevant_activities.count == 0
          # Only email the user if they haven't been emailed about it yet.
          Mailer.user_new_need_with_matching_skills(user, self, self.skills).deliver
          Activity.create(
            subject: self,
            description: 'Mailed about need due to relevant skills.',
            user: user
          )
        end


      end
    end





    # Also this should only send once... or send with an update... or something? Keep records on it some how.
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

  def validate_is_public
    	if self.need_stage.admin_incoming?
		self.is_public = false
   	elsif self.need_stage.admin_completed?
		self.is_public = false
   	end
   	true
  end

  def skills_count
    self.skills.count
  end

  def total_contributed
    money = Money.new(0, "USD")
    	self.contributions.each do |contribution|
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

end
