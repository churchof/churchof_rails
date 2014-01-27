class Need < ActiveRecord::Base
	resourcify
	
  	belongs_to :user_posted_by, :foreign_key => 'user_id_posted_by', :class_name => "User"
  	belongs_to :user_church_admin, :foreign_key => 'user_id_church_admin', :class_name => "User"

	validates :description, presence: true, length: { minimum: 2 }
	validates :title, presence: true
	validates :user_id_posted_by, presence: true
end
