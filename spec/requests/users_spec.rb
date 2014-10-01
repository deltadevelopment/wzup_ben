require 'rails_helper'

RSpec.describe "Users", :type => :request do

  describe "GET /user/id" do 

    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    
    let(:full_user_response) {
      { 'user' =>
        { 'id' => user1.id,
          'username' => user1.username,
          'display_name' => user1.display_name,
          'availability' => user1.availability,
          'phone_number' => user1.phone_number,
          'private_profile' => user1.private_profile }
      }.to_json
    }
    
    let(:public_user_response){
        { 'user' =>
            { 'id' => user1.id,
            'username' => user1.username,
            'display_name' => user1.display_name,
            'private_profile' => false }
      }.to_json
    }

    let(:private_user_response){
      { 'user' =>
        { 'id' => user1.id,
          'username' => user1.username,
          'private_profile' => user1.private_profile }
      }.to_json
    }

    context "as a followee" do
      context "user is private" do
        it "should return full json body" do

          # TODO: post call should be stubbed out
          post "user/#{user1.id}/follow/#{user2.id}", nil, { 'X-AUTH-TOKEN' => user1.session.auth_token}
          get "user/#{user1.id}", nil, { 'X-AUTH-TOKEN' => user2.session.auth_token }

          expect(response.body).to be_json_eql(full_user_response)
        end
      end
    end

    context "without relation" do
      context "user is private" do
        it "should return limited amount of data" do
            get "user/#{user1.id}", nil, { 'X-AUTH-TOKEN' => user2.session.auth_token}
            expect(response.body).to be_json_eql(private_user_response)
        end 
      end

      context "user has a public profile" do 
        it "should return full json body, except phone number and availiability" do
          user1.update_attributes(private_profile: false)

          get "user/#{user1.id}", nil, { 'X-AUTH-TOKEN' => user2.session.auth_token }
          
          expect(response.body).to be_json_eql(public_user_response)
        end
      end
    end

    context "user is requesting his own profile" do
      it "should return full json body" do
        get "user/#{user1.id}", nil, { 'X-AUTH-TOKEN' => user1.session.auth_token }
        
        expect(response.body).to be_json_eql(full_user_response)
      end
    end
  end
  
  describe "POST /user/register" do
    
    let(:user) { FactoryGirl.build(:user) }

    let(:required_parameters) {
      { 'user' => 
        { 'username' => user.username,
          'password' => user.password,
          'email' => user.email }
      }
    }
    
    it "should create a user when given required fields" do
      post "user/register", required_parameters 
      expect(response).to have_http_status(201)
    end 

    it "should not create a user with invalid fields" do
      post "user/register", {'user' => {'email' => nil}}
      expect(response).to have_http_status(400)
    end
    
    it "should not create a user with missing fields" do
      post "user/register", {'user' => {'email' => 'abc@abc.com'}}
      expect(response).to have_http_status(400)
    end

  end

  describe "PUT /user/:id" do
    
    let(:user) { FactoryGirl.create(:user) } 

    let(:updated_params) {
      { 'user' => 
        { 'username' => user.username + 'n',
          'password' => user.password + 'n',
          'email' => user.email + 'n',
          'display_name' => user.display_name + 'n',
          'phone_number' => user.phone_number + 1 }
      }
    }

    it "should update user when given right parameters" do
      put "user/#{user.id}", updated_params, {'X-AUTH-TOKEN' => user.session.auth_token } 
      expect(response).to have_http_status(200)
    end

    it "should not update a user with an invalid field" do
      put "user/#{user.id}", { 'user' => { 'email' => '123' } }, { 'X-AUTH-TOKEN' => user.session.auth_token }
      expect(response).to have_http_status(400)
    end

    it "should not update user with without correct session" do
      put "user/#{user.id}", updated_params, {'X-AUTH-TOKEN' => user.session.auth_token + '1' } 
      expect(response).to have_http_status(403)
    end
    
  end

  describe "DELETE user/:id", focus: true do
    
    let(:user) { FactoryGirl.create(:user) }
    
    it "should delete user with valid session" do
      delete "user/#{user.id}", nil, {'X-AUTH-TOKEN' => user.session.auth_token }
      expect(response).to have_http_status(200)
    end

    it "should not delete user with invalid session" do
      delete "user/#{user.id}", nil, {'X-AUTH-TOKEN' => user.session.auth_token + '1'}
      expect(response).to have_http_status(403)
    end
  end

end
