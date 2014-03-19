ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
:address => "smtp.gmail.com",
:port => 587,
:domain => "gmail.com",
:user_name => "churchoflexington@gmail.com",
:password => ENV['GMAIL_PASSWORD'],
:authentication => "plain",
:enable_starttls_auto => true
}