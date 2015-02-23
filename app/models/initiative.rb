class Initiative < ActiveRecord::Base
	has_many :initiative_metrics
	has_many :skills
end
