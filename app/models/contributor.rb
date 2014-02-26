class Contributor < ActiveRecord::Base
  validates :email, uniqueness: true
  has_many :contributions
end