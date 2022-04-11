class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session
    before_action :configure_permitted_parameters, if: :devise_controller?

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :last_name, :contact_number, :role])
        devise_parameter_sanitizer.permit(:invite, keys: [:first_name, :last_name, :contact_number, :role])
        devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :contact_number, :email, :password, :password_confirmation])
    end
end
