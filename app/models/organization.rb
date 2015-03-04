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


  def is_stripe_linked
    if (self.stripe_publishable_key && self.stripe_uid && self.stripe_access_code)
      return true
    end
    return false
  end


  def able_to_give_to
      if self.is_verified
        if self.is_stripe_linked
          return true
        end
      end
      return false
  end


  def self.all_orgs_able_to_give_to
    all_orgs_able_to_give_to = Array.new()

    Organization.all.each do |organization|
      if organization.able_to_give_to
        all_orgs_able_to_give_to << organization
      end
    end

    all_orgs_able_to_give_to
  end

  # scope :able_to_give_to, -> {where(is_stripe_linked: true, is_verified: true)}


end