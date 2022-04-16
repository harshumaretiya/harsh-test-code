require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "POST /api/v1/sign_in" do
    it 'should login new user' do
      post "/api/v1/sign_in", params: {
        user: 
        {
            email: "hars.u@madhubaninfotech.in",
            password: "123456789",
            platform: "web"
        }
    }
      response_body = JSON(response.body)

      expect(response_body['success']).to eql(true)
    end

    it 'should not create user and perform validation ' do
      post "/api/v1/sign_up", params: {
        user: 
        {
            email: "hars.u@madhubaninfotech.in",
            password: "123456789",
            platform: "web"
        }
      } 
      response_body = JSON(response.body)

      expect(response_body['success']).to eql(false)
      expect(response_body['errors']).to eql("Email does not Exist.")
    end  

  end
end
