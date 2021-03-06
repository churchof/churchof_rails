class TimeContribution < ActiveRecord::Base
  belongs_to :need
  belongs_to :user

  after_create :mail_to_need_leader_if_exists_new_volunteer
  after_create :mail_to_notify_if_fully_volunteered
  after_update :mail_to_need_leader_if_exists_volunteer_status_changed
  after_create :mail_instructions_to_volunteer
  after_update :mail_instructions_to_volunteer_if_renewed

  def mail_instructions_to_volunteer
    Mailer.delay.volunteer_instructions_to_volunteer(user.id, need.id)
  end

  def mail_instructions_to_volunteer_if_renewed
    if self.cancelled_changed?
      if self.cancelled
      else
        Mailer.delay.volunteer_instructions_to_volunteer(user.id, need.id)
      end
    end
  end

  def mail_to_need_leader_if_exists_new_volunteer
  	if need.user_need_leader
        past_relevant_activities = Activity.where(user_id: need.user_need_leader.id, subject: self, description: 'Mailed because need they lead has a new volunteer.')
        if past_relevant_activities.count == 0
          Activity.create!(
            subject: self,
            description: 'Mailed because need they lead has a new volunteer.',
            user_id: need.user_need_leader.id
          )
          Mailer.delay.need_leader_new_volunteer_added(need.user_need_leader.id, user.id, need.id)
        end
  	end
  end

  def mail_to_notify_if_fully_volunteered
    if need.total_volunteers >= need.total_needed_volunteers

      # Alert the Need Leader
    	if need.user_need_leader
          past_relevant_activities = Activity.where(user_id: need.user_need_leader.id, subject: self, description: 'Mailed because need they lead is fully volunteered.')
          if past_relevant_activities.count == 0
            Activity.create!(
              subject: self,
              description: 'Mailed because need they lead is fully volunteered.',
              user_id: need.user_need_leader.id
            )
            Mailer.delay.need_leader_need_fully_volunteered(need.user_need_leader.id, need.id)
          end
    	end

      # Alert the volunteers
      self.need.time_contributions.each do |time_contribution|
        if time_contribution.user
          past_relevant_activities = Activity.where(user_id: time_contribution.user.id, subject: self.need, description: 'Mailed news that need is fully volunteered to volunteer.')
          if past_relevant_activities.count == 0
            # Only email the user if they haven't been emailed about it yet.
            Activity.create!(
              subject: self.need,
              description: 'Mailed news that need is fully volunteered to volunteer.',
              user_id: time_contribution.user.id
            )
            Mailer.delay.volunteer_need_volunteered_for_fully_volunteered(time_contribution.user.id, self.need.id)
          end
        end
      end

      # Alert the contributors (with/without accounts)
      self.need.contributions.succeded.not_reimbursed.each do |contribution|
        if contribution.user
          past_relevant_activities = Activity.where(user_id: contribution.user.id, subject: self.need, description: 'Mailed news that need is fully volunteered to contributor (with account).')
          if past_relevant_activities.count == 0
            # Only email the user if they haven't been emailed about it yet.
            Activity.create!(
              subject: self.need,
              description: 'Mailed news that need is fully volunteered to contributor (with account).',
              user_id: contribution.user.id
            )
            Mailer.delay.user_need_contributed_to_fully_volunteered(contribution.user.id, self.need.id)
          end
        elsif contribution.contributor
          past_relevant_activities = Activity.where(user_id: nil, subject: self.need, description: 'Mailed news that need is fully volunteered to contributor (without account - #{contribution.contributor.email}).')
          if past_relevant_activities.count == 0
            # Only email the user if they haven't been emailed about it yet.
            Activity.create!(
              subject: self.need,
              description: 'Mailed news that need is fully volunteered to contributor (without account - #{contribution.contributor.email}).',
              user: nil
            )
            Mailer.delay.contributor_need_contributed_to_fully_volunteered(contribution.contributor.id, self.need.id)
          end
        end
      end

    end
  end

  def mail_to_need_leader_if_exists_volunteer_status_changed
    if self.cancelled_changed?
	  	if need.user_need_leader
	  		if self.cancelled
          		Mailer.delay.need_leader_new_volunteer_status_changed_to_cancelled(need.user_need_leader.id, user.id, need.id)
	  		else
          		Mailer.delay.need_leader_new_volunteer_status_changed_to_renewed(need.user_need_leader.id, user.id, need.id)
	  		end
	  	end
    end
  end

end