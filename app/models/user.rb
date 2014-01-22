require 'role_model'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :needs
       
  include RoleModel
 
  # optionally set the integer attribute to store the roles in,
  # :roles_mask is the default
  roles_attribute :roles_mask

  # declare the valid roles -- do not change the order if you add more
  # roles later, always append them at the end!
  roles :super_admin, :church_admin, :need_poster

  def full_name
  	first_name + " " + last_name
  end

  def gravatar_url
    "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(email.strip.downcase)}"
  end
end
