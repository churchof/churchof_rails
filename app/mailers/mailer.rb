class Mailer < ActionMailer::Base

def church_admin_new_need_admin_incoming(need, user_posted_by, user_church_admin)
	@need = need
	@user_posted_by = user_posted_by
	@user_church_admin = user_church_admin
	mail :to => user_church_admin.email, :from => "churchoflexington@gmail.com", :subject => "Church Admin Incoming Need: #{need.title}"
end

def user_new_need_with_matching_skills(user, need, skills)
	@user = user
	@need = need
	@skills = skills
	mail :to => user.email, :from => "churchoflexington@gmail.com", :subject => "New Need Matching Skills: #{need.title}"
end

def church_admin_need_recieved_contribution(user_church_admin, need, contribution)
	@user_church_admin = user_church_admin
	@need = need
	@contribution = contribution
	mail :to => user_church_admin.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Admin) Recieved Contribution: #{need.title}, #{contribution.amount}"
end

def user_posted_by_need_recieved_contribution(user_posted_by, need, contribution)
	@user_posted_by = user_posted_by
	@need = need
	@contribution = contribution
	mail :to => user_posted_by.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Posted) Recieved Contribution: #{need.title}, #{contribution.amount}"
end

def user_posted_by_need_moved_to_in_progress(user_posted_by, need, user_church_admin)
	@user_posted_by = user_posted_by
	@need = need
	@user_church_admin = user_church_admin
	mail :to => user_posted_by.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Posted) Moved to In Progress: #{need.title}"
end

end