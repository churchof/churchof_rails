class Need < ActiveRecord::Base
	extend Enumerize
	resourcify

	enumerize :need_stage, in: {:admin_incoming => 1, :admin_in_progress => 2, :admin_completed => 3}, default: :admin_incoming
	enumerize :gender, in: {:unknown => 1, :male => 2, :female => 3}

  	belongs_to :user_posted_by, :foreign_key => 'user_id_posted_by', :class_name => "User"
  	belongs_to :user_church_admin, :foreign_key => 'user_id_church_admin', :class_name => "User"

	validates :title, presence: true
	validates :title_public, presence: true
	validates :description, presence: true, length: { minimum: 2 }
	validates :description_public, presence: true, length: { minimum: 2 }
	validates :user_id_posted_by, presence: true
	validates :user_id_church_admin, presence: true

	before_save :validate_is_public
	
	has_many :expenses

    def validate_is_public
      	if self.need_stage.admin_incoming?
			self.is_public = false
     	elsif self.need_stage.admin_completed?
			self.is_public = false
     	end
     	true
    end

    def total_contributed
    	integer i = 0
      	self.con do |expense|
			i = i + expense.amount
      	end
      	i
    end

    def total_expenses
    	integer i = 0
      	self.expenses do |expense|
			i = i + expense.amount
      	end
      	i
    end

end