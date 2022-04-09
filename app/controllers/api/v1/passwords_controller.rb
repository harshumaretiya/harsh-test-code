class Api::V1::PasswordsController < Api::V1::AuthenticatedController 
  skip_before_action :authorize_user!, only: %i[forgot_password reset_password], raise: false

  #POST password/forgot_password
  def forgot_password
    ug = UserGenerator.new

    begin
      ug.forgot_password!(user_params) 
    rescue UserGenerator::ParameterNotFound, UserGenerator::DuplicateError => e
      render_exception(e, 422) && return
    end
    render json: { success: true, data: {}, errors: [] }, status: 200
  end
 
  #POST password/reset_password
  def reset_password
	  ug = UserGenerator.new

		begin
			ug.reset_password!(user_params)
		rescue UserGenerator::ParameterNotFound, UserGenerator::DuplicateError => e
			render_exception(e, 422) && return
		end
		render json: { success: true, data: {}, errors: [] }, status: 200
  end
  
  #PUT password/change_password
  def change_password
    ug = UserGenerator.new
    
    begin
      authorize! :change_password, @current_user

			ug.change_password!(user_params, current_user)
		rescue UserGenerator::ParameterNotFound, UserGenerator::DuplicateError => e
			render_exception(e, 422) && return
		end
		render json: { success: true, data: {}, errors: [] }, status: 200
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :token, :reset_password_token, :old_password, :password_confirmation)
  end
end
