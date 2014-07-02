class ResourceFlag < ActiveRecord::Base
	validates :resource_id, presence: true
	validates :user_id_church_admin, presence: true
	belongs_to :resource, :foreign_key => 'resource_id', :class_name => "Resource"
  belongs_to :user_church_admin, :foreign_key => 'user_id_church_admin', :class_name => "User"
  scope :flagged, -> { where(flagged: true) }

  after_create :check_if_resource_should_be_flagged
  after_update :check_if_resource_should_be_flagged

  def check_if_resource_should_be_flagged
  	if !self.resource.flagged
	    if self.resource.resource_flags.flagged.count >=	(User.with_role(:church_admin).count / 2.0)
	      self.resource.update_column(:flagged, true)
	    end
  	end
  end
end