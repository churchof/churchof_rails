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

  # after the initial creation this will take the contributions from the appropriate contributor.
  # in the event that the email has been changed to another contributor account it will pick up those records as well.
  after_save :assign_past_contributor_contributions_to_user
  
  def assign_past_contributor_contributions_to_user
    contributor = Contributor.find_by_email(email)
    if contributor
      contributor.contributions.update_all(:user_id => id, :contributor_id => nil)
      contributor.destroy
    end
    true
  end

end
