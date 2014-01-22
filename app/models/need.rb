class Need < ActiveRecord::Base
	belongs_to :user

	validates :description, presence: true, length: { minimum: 2 }
	validates :title, presence: true
	validates :user_id, presence: true
end
