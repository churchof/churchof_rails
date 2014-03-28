class Update < ActiveRecord::Base
	validates :title, presence: true
	validates :content, presence: true
	belongs_to :need
	has_many :images
	accepts_nested_attributes_for :images, :allow_destroy => true
end