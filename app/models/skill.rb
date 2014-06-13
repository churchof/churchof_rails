class Skill < ActiveRecord::Base
  has_and_belongs_to_many :needs
  has_and_belongs_to_many :users
   has_and_belongs_to_many :resources
  validates :name, presence: true
  validates :name, uniqueness: true
  default_scope :order => 'skills.name ASC'
end