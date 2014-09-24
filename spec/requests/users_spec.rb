require 'rails_helper'

RSpec.describe "Users", :type => :request do

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

  describe "GET /user/id" do 

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

      context "user is public" do
        it "should return full json body, except phone number and availiability" do
          user1.update_attributes(private_profile: false)

          get "user/#{user1.id}", nil, { 'X-AUTH-TOKEN' => user2.session.auth_token }
          
          expect(response.body).to be_json_eql(public_user_response)
        end
      end
    end

  end

  context "user is requesting his own profile" do
    it "should return full json body" do
    end
  end

end
