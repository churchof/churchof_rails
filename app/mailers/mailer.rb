class Mailer < ActionMailer::Base

# Church Admins

def church_admin_new_need_admin_incoming(need, user_posted_by, user_church_admin)
	@need = need
	@user_posted_by = user_posted_by
	@user_church_admin = user_church_admin
	mail :to => user_church_admin.email, :from => "churchoflexington@gmail.com", :subject => "Church Admin Incoming Need: #{need.title}"
end

def church_admin_need_recieved_contribution(user_church_admin, need, contribution)
	@user_church_admin = user_church_admin
	@need = need
	@contribution = contribution
	mail :to => user_church_admin.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Admin) Recieved Contribution: #{need.title}, #{contribution.amount}"
end

def church_admin_need_fully_funded(user_church_admin, need)
	@user_church_admin = user_church_admin
	@need = need
	mail :to => user_church_admin.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Admin) Is Fully Funded: #{need.title}"
end


# Need Posters

def user_posted_by_need_moved_to_in_progress(user_posted_by, need, user_church_admin)
	@user_posted_by = user_posted_by
	@need = need
	@user_church_admin = user_church_admin
	mail :to => user_posted_by.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Posted) Moved to In Progress: #{need.title}"
end

def user_posted_by_need_recieved_contribution(user_posted_by, need, contribution)
	@user_posted_by = user_posted_by
	@need = need
	@contribution = contribution
	mail :to => user_posted_by.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Posted) Recieved Contribution: #{need.title}, #{contribution.amount}"
end

def user_posted_by_need_fully_funded(user_posted_by, need)
	@user_posted_by = user_posted_by
	@need = need
	mail :to => user_posted_by.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Posted) Is Fully Funded: #{need.title}"
end

def user_posted_by_public_update_added(user_posted_by, need, update)
	@user_posted_by = user_posted_by
	@need = need
	@update = update
	mail :to => user_posted_by.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Posted) Has a New Public Update: #{need.title}"
end


# Users

def user_new_need_with_matching_skills(user, need, skills)
	@user = user
	@need = need
	@skills = skills
	mail :to => user.email, :from => "churchoflexington@gmail.com", :subject => "New Need Matching Skills: #{need.title_public}"
end

def user_need_contributed_to_public_update_added(user, need, update)
	@user = user
	@need = need
	@update = update
	mail :to => user.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Contributed To) Has a New Public Update: #{need.title_public}"
end

def user_need_contributed_to_fully_funded(user, need)
	@user = user
	@need = need
	mail :to => user.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Contributed To) Is Fully Funded: #{need.title_public}"
end


# Contributors

def contributor_need_contributed_to_public_update_added(contributor, need, update)
	@contributor = contributor
	@need = need
	@update = update
	mail :to => contributor.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Contributed To) Has a New Public Update: #{need.title_public}"
end

def contributor_need_contributed_to_fully_funded(contributor, need)
	@contributor = contributor
	@need = need
	mail :to => contributor.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Contributed To) Is Fully Funded: #{need.title_public}"
end


end