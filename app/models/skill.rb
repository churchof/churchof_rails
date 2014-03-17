class Skill < ActiveRecord::Base
	has_and_belongs_to_many :needs
  	validates :title, presence: true
  	validates :title, uniqueness: true
end