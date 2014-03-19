class Mailer < ActionMailer::Base

def church_admin_new_need_admin_incoming(need)
	mail :to => need, :from => "churchoflexington@gmail.com", :subject => "Subject line"
end

end