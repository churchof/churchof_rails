class Contributor < ActiveRecord::Base
  validates :email, uniqueness: true
  belongs_to :user
  has_many :contributions
end