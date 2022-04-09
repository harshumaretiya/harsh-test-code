class Api::V1::InvitationsController < Api::V1::AuthenticatedController
  skip_before_action :authorize_user!, only: %i[accept_invitation], raise: false

  # POST /send_invitation
  def send_invitation
    ug = UserGenerator.new

    begin
      authorize! :send_invitation, @current_user
      ug.send!(invite_params, @current_user, @current_owner)
    rescue UserGenerator::ParameterNotFound, UserGenerator::DuplicateError => e
      render_exception(e, 422) && return
    end
    render json: { success: true, data: {}, errors: [] }, status: 200
  end

  # POST /send_reinvitation
  def send_reinvitation
    ug = UserGenerator.new

    begin
      authorize! :send_reinvitation, @current_user
      ug.resend_invite!(invite_params)
    rescue UserGenerator::ParameterNotFound, UserGenerator::DuplicateError => e
      render_exception(e, 422) && return
    end
    render json: { success: true, data: {}, errors: [] }, status: 200
  end


  
  # POST /accept_invitation
  def accept_invitation
    ug = UserGenerator.new
  
    begin
      ug.accept_invite!(invite_params)
    rescue UserGenerator::ParameterNotFound, UserGenerator::DuplicateError => e
      render_exception(e, 422) && return
    end
    render json: { success: true, data: {}, errors: [] }, status: 200
  end

  private


  def invite_params
    params.require(:user).permit(:id, :email, :invitation_token, :role, :first_name, :last_name, :password, :contact_number)
  end
end