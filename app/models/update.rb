class Update < ActiveRecord::Base
	validates :title, presence: true
	validates :content, presence: true
	belongs_to :need
	has_many :images
	accepts_nested_attributes_for :images, :allow_destroy => true

	after_create :mail_notifications_to_associated_users

  	def mail_notifications_to_associated_users

        past_relevant_activities = Activity.where(user_id: self.need.user_posted_by.id, subject: self, description: 'Mailed news that need recieved public update to need poster.')
        if past_relevant_activities.count == 0
          # Only email the user if they haven't been emailed about it yet.
          Mailer.user_posted_by_public_update_added(self.need.user_posted_by, self.need, self).deliver
          Activity.create(
            subject: self,
            description: 'Mailed news that need recieved public update to need poster.',
            user: self.need.user_posted_by
          )
        end

	    self.need.contributions.succeded.not_reimbursed.each do |contribution|
	      if contribution.user
	        past_relevant_activities = Activity.where(user_id: contribution.user.id, subject: self, description: 'Mailed news that need recieved public update to contributor (with account).')
	        if past_relevant_activities.count == 0
	          # Only email the user if they haven't been emailed about it yet.
	          Mailer.user_need_contributed_to_public_update_added(contribution.user, self.need, self).deliver
	          Activity.create(
	            subject: self,
	            description: 'Mailed news that need recieved public update to contributor (with account).',
	            user: contribution.user
	          )
	        end
	      elsif contribution.contributor
	        past_relevant_activities = Activity.where(user_id: nil, subject: self, description: 'Mailed news that need recieved public update to contributor (without account - #{contribution.contributor.email}).')
	        if past_relevant_activities.count == 0
	          # Only email the user if they haven't been emailed about it yet.
	          Mailer.contributor_need_contributed_to_public_update_added(contribution.contributor, self.need, self).deliver
	          Activity.create(
	            subject: self,
	            description: 'Mailed news that need recieved public update to contributor (without account - #{contribution.contributor.email}).',
	            user: nil
	          )
	        end
	      end
	    end

	end



end