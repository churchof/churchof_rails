ActionMailer::Base.delivery_method = :smtp  
ActionMailer::Base.smtp_settings = {            
  :address              => "smtp.zoho.com", 
  :port                 => 465,                 
  :user_name            => 'no-reply@church-of.com',
  :password             => ENV['ZOHO_PASSWORD'],         
  :authentication       => :login,
  :ssl                  => true,
  :tls                  => true,
  :enable_starttls_auto => true    
}