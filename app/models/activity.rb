class Activity < ActiveRecord::Base
	# This stopped being activity tracking and started being a way to make sure duplicate emails were avoided mainly.
	belongs_to :subject, polymorphic: true
  	belongs_to :user
end
