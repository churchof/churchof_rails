class User < ActiveRecord::Base
  rolify # :pending_need_poster, :need_poster, :pending_church_admin, :church_admin, :super_admin
  
  has_and_belongs_to_many :skills

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, presence: true
  validates :last_name, presence: true

  after_save :assign_past_contributor_contributions_to_user

  has_many :needs_posted_by, :foreign_key => 'user_id_posted_by', :class_name => "Need"
  has_many :needs_church_admin, :foreign_key => 'user_id_church_admin', :class_name => "Need"

  has_many :contributions

  has_attached_file :avatar, {
    :styles => {
      :thumb => ["50x50#", :png],
      :medium => ["100x100#", :png],
      :large => ["300x300#", :png]
    }
  }

  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/jpg', 'image/png']

  attr_reader :skill_tokens

  def skill_tokens=(ids)
    self.skills.delete_all
    ids.split(",").each do |id|
      self.skills << Skill.find(id)
    end
    self.save
  end

  def full_name
  	first_name + " " + last_name
  end

  def church_admin_needs_admin_incoming_count
    self.needs_church_admin.where(need_stage: 1).count
  end

  # after the initial creation this will take the contributions from the appropriate contributor.
  # in the event that the email has been changed to another contributor account it will pick up those records as well.
  def assign_past_contributor_contributions_to_user
    contributor = Contributor.find_by_email(email)
    if contributor
      contributor.contributions.update_all(:user_id => id, :contributor_id => nil)
      contributor.destroy
    end
    true
  end

end
