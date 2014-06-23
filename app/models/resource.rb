class Resource < ActiveRecord::Base
		extend Enumerize

	validates :title, presence: true
		validates :availability_status, presence: true
	validates :public_status, presence: true

	# add the geocode here 
	belongs_to :organization
		belongs_to :user

	geocoded_by :address, :if => :address_changed?   # can also be an IP address
  	after_validation :geocode          # auto-fetch coordinates
	enumerize :availability_status, in: {:fully_available => 1, :mostly_available => 2, :mostly_not_available => 3, :not_available => 4}, default: :fully_available	
	enumerize :public_status, in: {:available_to_public => 1, :available_internally_only => 2}, default: :available_to_public


  has_and_belongs_to_many :skills

  accepts_nested_attributes_for :skills, :allow_destroy => true


  scope :public, -> { where(public_status: 1) }

end