class User < ActiveRecord::Base
  rolify # :need_poster, :church_admin, :super_admin
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :needs_posted_by, :foreign_key => 'user_id_posted_by', :class_name => "Need"
  has_many :needs_church_admin, :foreign_key => 'user_id_church_admin', :class_name => "Need"

  has_many :contributions
  has_one :contributor

  has_attached_file :avatar, {
    :styles => {
      :thumb => ["50x50#", :png],
      :medium => ["100x100#", :png],
      :large => ["300x300>", :png]
    },
    :convert_options => {
      :thumb => "-gravity Center -crop 50x50+0+0",
      :thumb => "-gravity Center -crop 100x100+0+0",
    }
  }

  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/jpg', 'image/png']

  def full_name
  	first_name + " " + last_name
  end

  # after create
  # check if there is are any contributions with this email address if so associate them
  # check if there are any contributors with this email address if so associate them
  after_create :assign_past_contributor_record_and_past_contributions_to_user
  
  def assign_past_contributor_record_and_past_contributions_to_user

    logger.debug "This is from debug"
    logger.debug self.email

    Contributor.where(:email => self.email).first do |contributor|
      # associate that contributor with the user if one exists.
          logger.debug "This is from debug 2"

      contributor.update_attributes(:user => self)
    end
    Contribution.where(:email => self.email).first do |contribution|
          logger.debug "This is from debug 3"

      # associate that contribution with the user if one exists.
      contributor.update_attributes(:user => self)
    end
    true
  end

end
