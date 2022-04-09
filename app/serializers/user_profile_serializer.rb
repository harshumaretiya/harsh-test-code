class UserProfileSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :first_name, :email, :last_name

  attribute :role do |object|
    object.roles_name.first
  end

end
