ActionMailer::Base.delivery_method = :smtp  
ActionMailer::Base.smtp_settings = {            
  :address              => "smtp.zoho.com", 
  :port                 => 465,   
  :domain 				=> "zoho.com",
  :user_name            => "no-reply@church-of.com",
  :password             => ENV['ZOHO_PASSWORD'],         
  :authentication       => :plain,
  :ssl                  => true,
  :tls                  => true,
}