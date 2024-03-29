require 'rails_helper'

RSpec.describe "Followings", :type => :request do

  describe "GET /user/:id/followers and followees" do
    
    let(:following) { FactoryGirl.create(:following) }
    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }

    context "without relation" do
      context "user is private" do
        let(:expected_response) {
          {'error' => 'Not authorized'}.to_json
        }
        it "should return not authorized requesting followees" do
          get "user/#{following.user.id}/followees", nil, {'X-AUTH-TOKEN' => user.session.auth_token }
          expect(response.body).to be_json_eql(expected_response)
          expect(response).to have_http_status(403)
        end

        it "should return not authorized requesting followers" do
          get "user/#{following.followee.id}/followers", nil, {'X-AUTH-TOKEN' => user.session.auth_token }
          expect(response.body).to be_json_eql(expected_response)
          expect(response).to have_http_status(403)
        end

        it "should create following request when following" do
          expected_response = {'success' => 'Request created'}.to_json

          post "user/#{user2.id}/follow/#{user.id}", nil, {'X-AUTH-TOKEN' => user2.session.auth_token }
          expect(response.body).to be_json_eql(expected_response)
        end

      end

      context "user is public" do
        
        it "should return all followees" do
          following.user.update_attributes(private_profile: false)

          expected_response = {'followings' => [{
              'id' => following.id,
              'user' => {
                'id' => following.followee.id,
                'username' => following.followee.username }
              }]
            }.to_json

            get "user/#{following.user.id}/followees", nil, {'X-AUTH-TOKEN' => user.session.auth_token }
            expect(response.body).to be_json_eql(expected_response)
            expect(response).to have_http_status(200)
        end

        it "should return all followers" do
          following.followee.update_attributes(private_profile: false)

          expected_response = {'followings' => [{
              'id' => following.id,
              'user' => {
                'id' => following.user.id,
                'username' => following.user.username }
              }]
            }.to_json

            get "user/#{following.followee.id}/followers", nil, {'X-AUTH-TOKEN' => user.session.auth_token }
            expect(response.body).to be_json_eql(expected_response)
            expect(response).to have_http_status(200)
        end
      end
    end

    context "as the owner" do

      it "returns HTTP 201 when accepting a following request" do
          post "user/#{user2.id}/follow/#{user.id}", nil, {'X-AUTH-TOKEN' => user2.session.auth_token }
          post "user/#{user.id}/accept_following/#{user2.id}", nil, {'X-AUTH-TOKEN' => user.session.auth_token }

          expect(response).to have_http_status(201)
      end 

      it "should return all followees" do
        expected_response = {'followings' => [{
            'id' => following.id,
            'user' => {
              'id' => following.followee.id,
              'username' => following.followee.username }
            }]
          }.to_json

          get "user/#{following.user.id}/followees", nil, {'X-AUTH-TOKEN' => following.user.session.auth_token }
          expect(response.body).to be_json_eql(expected_response)
          expect(response).to have_http_status(200)
      end

      it "should return all followers" do
        expected_response = {'followings' => [{
            'id' => following.id,
            'user' => {
              'id' => following.user.id,
              'username' => following.user.username }
            }]
          }.to_json

          get "user/#{following.followee.id}/followers", nil, {'X-AUTH-TOKEN' => following.followee.session.auth_token }
          expect(response.body).to be_json_eql(expected_response)
          expect(response).to have_http_status(200)
      end

      it "should return 200 when deleting a relationship" do
        
        delete "user/#{following.user.id}/follow/#{following.followee.id}", nil, {'X-AUTH-TOKEN' => following.user.session.auth_token}

        expect(response).to have_http_status(200)
  

      end

    end

    context "as a follower" do

      it "should return all followees" do
        FactoryGirl.create(:following, user_id: following.followee.id, followee_id: following.user.id)

        expected_response = {'followings' => [{
            'id' => following.id,
            'user' => {
              'id' => following.followee.id,
              'username' => following.followee.username }
            }]
          }.to_json

          get "user/#{following.user.id}/followees", nil, {'X-AUTH-TOKEN' => following.followee.session.auth_token }
          expect(response.body).to be_json_eql(expected_response)
          expect(response).to have_http_status(200)
      end

      it "should return all followers" do

        expected_response = {'followings' => [{
            'id' => following.id,
            'user' => {
              'id' => following.user.id,
              'username' => following.user.username }
            }]
          }.to_json

          get "user/#{following.followee.id}/followers", nil, {'X-AUTH-TOKEN' => following.user.session.auth_token }
          expect(response.body).to be_json_eql(expected_response)
          expect(response).to have_http_status(200)
      end
    end
  end
end
