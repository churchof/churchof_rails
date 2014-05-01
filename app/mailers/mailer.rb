class Mailer < ActionMailer::Base

# include Resque::Mailer

# Church Admins

def church_admin_new_need_admin_incoming(need_id, user_posted_by_id, user_church_admin_id)
	@need = Need.find(need_id)
	@user_posted_by = User.find(user_posted_by_id)
	@user_church_admin = User.find(user_church_admin_id)
	mail :to => @user_church_admin.email, :from => "churchoflexington@gmail.com", :subject => "Church Admin Incoming Need: #{@need.title}"
end

def church_admin_need_recieved_contribution(user_church_admin_id, need_id, contribution_id)
	@user_church_admin = User.find(user_church_admin_id)
	@need = Need.find(need_id)
	@contribution = Contribution.find(contribution_id)
	mail :to => @user_church_admin.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Admin) Recieved Contribution: #{@need.title}, #{@contribution.amount}"
end

def church_admin_need_fully_funded(user_church_admin_id, need_id)
	@user_church_admin = User.find(user_church_admin_id)
	@need = Need.find(need_id)
	mail :to => @user_church_admin.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Admin) Is Fully Funded: #{@need.title}"
end


# Need Posters

def user_posted_by_need_moved_to_in_progress(user_posted_by_id, need_id, user_church_admin_id)
	@user_posted_by = User.find(user_posted_by_id)
	@need = Need.find(need_id)
	@user_church_admin = User.find(user_church_admin_id)
	mail :to => @user_posted_by.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Posted) Moved to In Progress: #{@need.title}"
end

def user_posted_by_need_recieved_contribution(user_posted_by_id, need_id, contribution_id)
	@user_posted_by = User.find(user_posted_by_id)
	@need = Need.find(need_id)
	@contribution = Contribution.find(contribution_id)
	mail :to => @user_posted_by.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Posted) Recieved Contribution: #{@need.title}, #{@contribution.amount}"
end

def user_posted_by_need_fully_funded(user_posted_by_id, need_id)
	@user_posted_by = User.find(user_posted_by_id)
	@need = Need.find(need_id)
	mail :to => @user_posted_by.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Posted) Is Fully Funded: #{@need.title}"
end

def user_posted_by_public_update_added(user_posted_by_id, need_id, update_id)
	@user_posted_by = User.find(user_posted_by_id)
	@need = Need.find(need_id)
	@update = Update.find(update_id)
	mail :to => @user_posted_by.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Posted) Has a New Public Update: #{@need.title}"
end


# Users

def user_new_need_with_matching_skills(user_id, need_id, skills_id)
	@user = User.find(user_id)
	@need = Need.find(need_id)
	@skills = Skill.find(skills_id)
	mail :to => @user.email, :from => "churchoflexington@gmail.com", :subject => "New Need Matching Skills: #{@need.title_public}"
end

def user_need_contributed_to_public_update_added(user_id, need_id, update_id)
	@user = User.find(user_id)
	@need = Need.find(need_id)
	@update = Update.find(update_id)
	mail :to => @user.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Contributed To) Has a New Public Update: #{@need.title_public}"
end

def user_need_contributed_to_fully_funded(user_id, need_id)
	@user = User.find(user_id)
	@need = Need.find(need_id)
	mail :to => @user.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Contributed To) Is Fully Funded: #{@need.title_public}"
end

def receipt_to_user(user_id, need_id, contribution_id)
	@user = User.find(user_id)
	@need = Need.find(need_id)
	@contribution = Contribution.find(contribution_id)
	mail :to => @user.email, :from => "churchoflexington@gmail.com", :subject => "Thanks for contributing to: #{@need.title_public}"
end


# Contributors

def contributor_need_contributed_to_public_update_added(contributor_id, need_id, update_id)
	@contributor = Contributor.find(contributor_id)
	@need = Need.find(need_id)
	@update = Update.find(update_id)
	mail :to => @contributor.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Contributed To) Has a New Public Update: #{@need.title_public}"
end

def contributor_need_contributed_to_fully_funded(contributor_id, need_id)
	@contributor = Contributor.find(contributor_id)
	@need = Need.find(need_id)
	mail :to => @contributor.email, :from => "churchoflexington@gmail.com", :subject => "Need (You Contributed To) Is Fully Funded: #{@need.title_public}"
end

def receipt_to_contributor(contributor_id, need_id, contribution_id)
	@contributor = Contributor.find(contributor_id)
	@need = Need.find(need_id)
	@contribution = Contribution.find(contribution_id)
	mail :to => @contributor.email, :from => "churchoflexington@gmail.com", :subject => "Thanks for contributing to: #{@need.title_public}"
end



end