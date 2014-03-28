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

end