require 'rails_helper'

RSpec.describe "Followings", :type => :request do

  describe "GET /user/:id/followers" do
    
    let(:following) { FactoryGirl.create(:following) }
    let(:user) { FactoryGirl.create(:user) }
    context "as a follower" do
      
    end
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
      end
    end

    context "as the owner" do
      it "should return all followees" do
        expected_response = {'followings' => [{
            'id' => following.id,
            'user' => {
              'id' => following.user.id,
              'username' => following.user.username },
            'followee' => {
              'id' => following.followee.id,
              'username' => following.followee.username }
            }]
          }.to_json

          get "user/#{following.user.id}/followees", nil, {'X-AUTH-TOKEN' => following.user.session.auth_token }
          binding.pry
          expect(response.body).to be_json_eql(expected_response)
          expect(response).to have_http_status(200)
      end

      # TODO: Validate that this test actually is correct
      it "should return all followers", focus: true do
        expected_response = {'followings' => [{
            'id' => following.id,
            'user' => {
              'id' => following.user.id,
              'username' => following.user.username },
            'followee' => {
              'id' => following.followee.id,
              'username' => following.followee.username }
            }]
          }.to_json
          get "user/#{following.followee.id}/followers", nil, {'X-AUTH-TOKEN' => following.followee.session.auth_token }
          expect(response.body).to be_json_eql(expected_response)
          expect(response).to have_http_status(200)
      end
    end
  end
end
