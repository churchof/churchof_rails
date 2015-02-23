class Organization < ActiveRecord::Base

			extend Enumerize

	validates :title, presence: true
	validates :organization_type, presence: true

  has_many :resources

  has_many :match_campaigns

  has_many :organization_roles
  geocoded_by :address, :if => :address_changed?   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  # this really doesnt hold it to anything currently... just used to display the right thing on the profile page... should be used to compare to another array that shows what types of orgs can set what types of orgroles to certain people. so the over_admin for each can go in and give their people certain roles, etc...
  enumerize :organization_type, in: {:church => 1, :organization => 2}, default: nil
 
  def is_verified
    self.organization_roles.count > 0
  end

end