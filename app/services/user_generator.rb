# frozen_string_literal: true
class UserGenerator
    class ParameterNotFound < StandardError; end
    class DuplicateError < StandardError; end
    class InvalidCredentials < StandardError; end
    class ConfirmationError < StandardError; end
  
    attr_reader :user, :role, :platform, :session
  
    def generate!(params)
      # validate parameters
      raise ParameterNotFound, 'Missing email' if params[:email].blank?

      user = User.find_by(email: params[:email].downcase)
      raise DuplicateError, 'This email has exists.' if user.present?
  
      if user.blank?
       user = User.new(params)
      end

      user.skip_confirmation_notification! 
      user.save!
      user.add_role :owner
      user.confirm
     # user.delay.send_confirmation_instructions
      @user = user
      
      true
    end
  
    def validate!(params)
      
      # validate parameters
      raise ParameterNotFound, 'Missing email' if params[:email].blank?
      raise ParameterNotFound, 'Missing password' if params[:password].blank?
      
      # validate
      user = User.find_by(email: params[:email].try(:downcase))
      raise ParameterNotFound, 'Email does not Exist.' if !user.present?
      raise InvalidCredentials, 'Invalid Password.' unless user.valid_password?(params[:password])
      raise ConfirmationError, 'Your email address is not confirmed yet, Please confirm it.' unless user.confirmed?
  
      session = UserSession.find_or_initialize_by(user: user, platform: params[:platform])
        
      # generate (unique) token & save
      session.token = generate_token

      user.save!
      session.save!
      # UserMailer.delay(run_at: 10.seconds.from_now).register_user(user.email, user.name, params[:password]) if user.new_record?

      # assign for instance
      @session = session
      @user = user
  
      true
    end
  
    def forgot_password!(params)
      # validate parameters
      raise ParameterNotFound, 'Missing email address' if params[:email].blank?
      user = User.find_by(email: params[:email])
      raise InvalidCredentials, 'Your email address is not found.' if user.nil?
      user.send_reset_password_instructions if user.present?
      
      true 
    end

    def confirmation!(params)
      # validate parameters
      raise ParameterNotFound, 'Missing confirmation token' if params[:confirmation_token].blank?

      user = User.find_by(confirmation_token: params[:confirmation_token])
      raise DuplicateError, 'Invalid confirmation token' if user.blank?

      user = User.confirm_by_token(params[:confirmation_token])
      user.confirmation_token = nil
      user.save!
      @user = user
      true
    end

    def reset_password!(params)
      # validate parameters
      raise ParameterNotFound, 'Missing reset password token' if params[:reset_password_token].blank?
    
      user = User.reset_password_by_token(reset_password_token: params[:reset_password_token])
      raise DuplicateError, 'Invalid reset password token' if user.blank?
      if user.present?
        user.password = params[:password]
        user.save!
      end
     
      @user = user
      true
    end

    def change_password!(params,current_user)
      # validate parameters
      raise ParameterNotFound, 'Missing old password' if params[:old_password].blank?
      raise ParameterNotFound, 'Missing new password' if params[:password].blank?
      raise ParameterNotFound, 'Missing confirm password' if params[:password_confirmation].blank?
      raise InvalidCredentials, 'Password are not same' unless params[:password_confirmation] == params[:password]
      raise InvalidCredentials, 'Old Password is incorrect' unless current_user.valid_password?(params[:old_password]) 
  
      user = current_user.reset_password(params[:password], params[:password_confirmation])
    
      @user = user
      true
    end

    def send!(params, current_user, current_owner)
      # validate parameters
      raise ParameterNotFound, 'Missing email address' if params[:email].blank?
      raise InvalidCredentials, 'Invalid role' unless User.roles.include?(params[:role])
      raise ParameterNotFound, 'Already registered email address.' if User.find_by_email(params[:email]).present?

      user =  User.invite!({
        email: params[:email],
        first_name: params[:first_name],
        last_name: params[:last_name], 
        owner_id: current_owner.id,
        contact_number: params[:contact_number],
        :skip_invitation => true
        },current_user) do |invitable| 
          invitable.add_role(params[:role]) 
        end  

      user.invite!

      @user = user
      true
    end

    def resend_invite!(params)
      # validate parameters
      raise ParameterNotFound, 'Missing User ID' if params[:id].blank?
      
      user = User.find_by_id(params[:id])
      raise DuplicateError, 'This user is already confirmed.' if user.confirmed?

      user.invite! if !user.confirmed?

      @user = user
      true
    end

    def accept_invite!(params)
      # validate parameters
      raise ParameterNotFound, 'Missing invitation token' if params[:invitation_token].blank?
      
      user = User.accept_invitation!(invitation_token: params[:invitation_token], password: params[:password])
      user.save!
      @user = user
      true
    end
    
    private
    
    def generate_token
      token_generator = SecureRandom.urlsafe_base64(128).tr('lIO0-', 'sxyzz')
      loop do
        token = token_generator
        break token unless UserSession.exists?(token: token)
      end
    end

  end
  