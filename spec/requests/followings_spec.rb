require 'rails_helper'

RSpec.describe "Followings", focus: true, :type => :request do

  describe "GET /user/:id/followers" do
    
    let(:following) { FactoryGirl.create(:following) }
    let(:user) { FactoryGirl.create(:user) }

    context "without relation" do
      context "user is private" do
        it "should return not authorized requesting followees" do
          get "user/#{following.user.id}/followees", nil, {'X-AUTH-TOKEN' => user.session.auth_token }
          expect(response.body).to have_json_path('error')
          expect(response).to have_http_status(403)
        end

        it "should return not authorized requesting followers" do
          get "user/#{following.followee.id}/followers", nil, {'X-AUTH-TOKEN' => user.session.auth_token }
          expect(response.body).to have_json_path('error')
          expect(response).to have_http_status(403)
        end
      end
    end

    context "as the owner" do

    end

  end
end
