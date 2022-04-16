require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  describe "POST /api/v1/sign_up" do
    it 'should create new user' do
      post "/api/v1/sign_up", params: {
        user: {
            email: "hars.u@madhubaninfotech.in",
            password: 123456789,
            first_name: "Madhuban",
            last_name: "Info Tech",
            contact_number: "1234567890"
        }
    } 
      response_body = JSON(response.body)

      expect(response_body['success']).to eql(true)
    end

    it 'should not create user and perform validation ' do
      post "/api/v1/sign_up", params: {
        user: {
            email: "hars.u@madhubaninfotech.in",
            password: 123456789,
            first_name: "Madhuban",
            last_name: "Info Tech"
            # contact_number: "1234567890"
        }
      } 
      response_body = JSON(response.body)

      expect(response_body['success']).to eql(false)
      expect(response_body['errors']).to eql("Validation failed: Contact number can't be blank")
    end  
    
    it 'should not create user and perform validation ' do
      post "/api/v1/sign_up", params: {
        user: {
            email: "hars.u@madhubaninfotech.in",
            password: 123456789,
            first_name: "Madhuban",
            # last_name: "Info Tech"
            contact_number: "1234567890"
        }
      } 
      response_body = JSON(response.body)

      expect(response_body['success']).to eql(false)
      expect(response_body['errors']).to eql("Validation failed: Last Number can't be blank")
    end

    it 'should not create user and perform validation ' do
      post "/api/v1/sign_up", params: {
        user: {
            email: "hars.u@madhubaninfotech.in",
            password: 123456789,
            first_name: "Madhuban",
            # last_name: "Info Tech"
            contact_number: "1234567890"
        }
      } 
      response_body = JSON(response.body)

      expect(response_body['success']).to eql(false)
      expect(response_body['errors']).to eql("Validation failed: Last Name can't be blank")
    end

    it 'should not create user and perform validation ' do
      post "/api/v1/sign_up", params: {
        user: {
            email: "hars.u@madhubaninfotech.in",
            password: 123456789,
            # first_name: "Madhuban",
            last_name: "Info Tech"
            contact_number: "1234567890"
        }
      } 
      response_body = JSON(response.body)

      expect(response_body['success']).to eql(false)
      expect(response_body['errors']).to eql("Validation failed: First Name can't be blank")
    end

  end
end
