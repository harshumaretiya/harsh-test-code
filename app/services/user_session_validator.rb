# frozen_string_literal: true
class UserSessionValidator
  class TokenValidatorError < StandardError; end
  class ParameterNotFound < TokenValidatorError; end
  class SessionNotFound < TokenValidatorError; end
  class SessionExpired < TokenValidatorError; end
  class UserNotFound < TokenValidatorError; end

  # TTL = ENV['SESSION_TIMEOUT'].try(:to_i) || 1.year

  attr_reader :user, :session

  def validate!(token, platform)
    # validate parameters
    raise ParameterNotFound, 'missing token' if token.blank?
    raise ParameterNotFound, 'missing platform' if platform.blank?
  
    # validate
    session = UserSession.find_by(token: token, platform: platform)
    raise SessionNotFound, 'invalid session' if session.blank?
    # raise SessionExpired, 'expired session' if session.updated_at < (Time.now - TTL)

     # fetch
     user = User.find_by id: session.user_id
     raise UserNotFound, 'missing customer' if user.blank?

    # assign for instance
    @session = session
    @user = user

    true
  end
end
