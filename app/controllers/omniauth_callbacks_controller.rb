
class OmniauthCallbacksController < ApplicationController

  skip_authorization_check

  def stripe_connect
    # @user = current_user
    # if @user.update_attributes({
    #   stripe_provider: request.env["omniauth.auth"].provider,
    #   stripe_uid: request.env["omniauth.auth"].uid,
    #   stripe_access_code: request.env["omniauth.auth"].credentials.token,
    #   stripe_publishable_key: request.env["omniauth.auth"].info.stripe_publishable_key
    # })
    #   # anything else you need to do in response..
    #   sign_in_and_redirect @user, :event => :authentication
    #   set_flash_message(:notice, :success, :kind => "Stripe") if is_navigational_format?
    # else
    #   session["devise.stripe_connect_data"] = request.env["omniauth.auth"]
    #   redirect_to new_user_registration_url
    # end

code = params[:code]
state = params[:state]


org = Organization.find(state)

params = {'client_secret' => ENV['STRIPE_SECRET_KEY'],
'code' => code,
'grant_type' => 'authorization_code'
}
x = Net::HTTP.post_form(URI.parse('https://connect.stripe.com/oauth/token'), params)


hash = JSON.parse x.body

if org.update_attributes({
  stripe_provider: "stripe",
  stripe_uid: hash["stripe_user_id"],
  stripe_access_code: hash["access_token"],
  stripe_publishable_key: hash["stripe_publishable_key"]
})
redirect_to organization_roles_path, :flash => { :alert => "Connected to Stripe." }
else

end

# curl -X POST https://connect.stripe.com/oauth/token \
#   -d client_secret=sk_test_cNU2dJ9gYljZE5iilwizqWEM \
#   -d code=AUTHORIZATION_CODE \
#   -d grant_type=authorization_code



  end
  
end
