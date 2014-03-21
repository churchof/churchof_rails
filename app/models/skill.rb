class Skill < ActiveRecord::Base
	has_and_belongs_to_many :needs
  	validates :name, presence: true
  	validates :name, uniqueness: true
end