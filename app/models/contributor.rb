class Contributor < ActiveRecord::Base
  validates :email, uniquness: true

  has_many :contributions
end
