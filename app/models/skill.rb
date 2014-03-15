class Skill < ActiveRecord::Base
	has_many :needs
  	validates :title, presence: true
  	validates :title, uniqueness: true
end