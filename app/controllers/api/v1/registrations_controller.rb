class Api::V1::RegistrationsController < Api::V1::AuthenticatedController
	skip_before_action :authorize_user!, only: %i[create], raise: false

 # POST /user/sign_up
 def create
		ug = UserGenerator.new
	
		begin
			ug.generate!(user_params)
		rescue UserGenerator::ParameterNotFound, UserGenerator::DuplicateError => e
			render_exception(e, 422) && return
    end
		json_response(UserValidateSerializer.new(ug.user).serializable_hash[:data][:attributes])
	end
	
  private

  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :contact_number, :password_confirmation)
  end
end