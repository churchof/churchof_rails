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

  def full_name
  	first_name + " " + last_name
  end

  def gravatar_url
    "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(email.strip.downcase)}"
  end
end
