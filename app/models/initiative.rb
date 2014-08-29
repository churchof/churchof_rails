class Initiative < ActiveRecord::Base
	has_many :initiative_metrics
	has_and_belongs_to_many :skills
end
