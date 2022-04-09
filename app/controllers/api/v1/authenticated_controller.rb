module Api
  module V1
    class AuthenticatedController < BaseController
      before_action :authorize_user!

      def current_user
        @current_user
      end

      def current_owner
        @current_owner
      end

      def current_session
        @current_session
      end

      private

      def authorize_user!
          @tv = UserSessionValidator.new
          
          begin
          token = request.headers['HTTP_AUTHENTICATION_TOKEN'] || request.headers['Authentication_Token']
          platform = request.headers['x-platform'] || request.headers['HTTP_PLATFORM']
           # validate parameters
          raise 'Missing authentication_token' if token.blank?
          @tv.validate!(token, platform)
          @current_user = @tv.user
          @current_owner = (@tv.user.has_role? :owner) ? @tv.user : @tv.user.owner
          @current_session = @tv.session
          # @current_role = @current_user.user_country_roles.find_by(country_id: @country_id) if @country_id 
          # raise 'Invalid country_id' if @current_role.blank?
          rescue UserSessionValidator::TokenValidatorError => e
            raise e.message
          end
      end
    end
  end
end
