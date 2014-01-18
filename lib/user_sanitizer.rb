class User::ParameterSanitizer < Devise::ParameterSanitizer
    private
    def account_update
        default_params.permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
    end
end