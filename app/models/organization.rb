class Organization < ActiveRecord::Base
	validates :title, presence: true

	# add the geocode here 
end