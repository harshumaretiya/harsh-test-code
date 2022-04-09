class UserSessionSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :first_name, :email, :last_name

  attribute :token do |user_validate, params|  
    params[:token]
  end

end