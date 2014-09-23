require 'rails_helper'

RSpec.describe "Users", :type => :request do

  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }

  describe "GET /user/id" do 

    context "user is private" do

      context "requester is not a followee of user" do

        it "should return limited amount of data" do
          expected_response =
            { 'user' =>
              { 'id' => user1.id,
                'username' => user1.username,
                'private_profile' => user1.private_profile }
            }.to_json

            get "user/#{user1.id}", nil, { 'X-AUTH-TOKEN' => user1.session.auth_token}
          expect(response.body).to be_json_eql(expected_response)
        end 

      end

      context "requester is a followee of user" do

        it "should return full json body" do
          expected_response =
            { 'user' =>
              { 'id' => user1.id,
                'username' => user1.username,
                'display_name' => user1.display_name,
                'availability' => user1.availability,
                'phone_number' => user1.phone_number,
                'private_profile' => user1.private_profile }
            }.to_json

          # TODO: This call should be stubbed out
            post "user/#{user1.id}/follow/#{user2.id}", nil, { 'X-AUTH-TOKEN' => user1.session.auth_token}
            get "user/#{user1.id}", nil, { 'X-AUTH-TOKEN' => user2.session.auth_token }

          expect(response.body).to be_json_eql(expected_response)
        end

      end

    end

    describe "user is public" do

    end

  end

end
