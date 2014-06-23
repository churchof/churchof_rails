class Organization < ActiveRecord::Base
	validates :title, presence: true

  has_many :resources

  has_many :organization_roles
  geocoded_by :address, :if => :address_changed?   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates
end