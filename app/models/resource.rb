class Resource < ActiveRecord::Base
	validates :title, presence: true
	# add the geocode here 
	belongs_to :organization
end