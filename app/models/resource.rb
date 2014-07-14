class Resource < ActiveRecord::Base
		extend Enumerize

  has_many :resource_flags
  has_many :resource_events

	validates :title, presence: true
		# validates :availability_status, presence: true
	validates :public_status, presence: true

	# add the geocode here 
	belongs_to :organization
		belongs_to :user


  # Not that the geocoding is based on the first public address and none of the others are geocoded.
	geocoded_by :address, :if => :address_changed?   # can also be an IP address
  	after_validation :geocode          # auto-fetch coordinates
	enumerize :availability_status, in: {:fully_available => 1, :mostly_available => 2, :mostly_not_available => 3, :not_available => 4}, default: nil
	enumerize :public_status, in: {:available_to_public => 1, :available_internally_only => 2}, default: :available_to_public

  has_and_belongs_to_many :skills

  accepts_nested_attributes_for :skills, :allow_destroy => true
  accepts_nested_attributes_for :resource_events, :allow_destroy => true

  scope :public, -> { where(public_status: 1, flagged: false) }






  def current_percentage_flagged
    self.resource_flags.flagged.count / (User.with_role(:church_admin).count * 1.0)
  end

  def resource_flag_for_user(user_id_to_check)
    self.resource_flags.where(user_church_admin: User.find(user_id_to_check)).first
  end

  def resource_flag_for_user_id(user_id_to_check)
    resource_flag = self.resource_flags.where(user_church_admin: User.find(user_id_to_check)).first
    resource_flag.id
  end

  def is_verified
    at_least_one = false
    self.user.organization_roles.where(role_type: 1).each do |organization_role|
      if organization_role.organization == self.organization
        at_least_one = true
      end
    end
    at_least_one
  end


end