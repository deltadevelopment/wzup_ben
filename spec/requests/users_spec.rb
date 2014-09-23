require 'rails_helper'

RSpec.describe "Users", :type => :request do

  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }

  let(:session1) { FactoryGirl.create(:session) }

  describe "GET /user/id" do 

    context "user is private" do

      context "requester is not a followee of user" do

        it "should return limited amount of data" do
          binding.pry
          user1.private_profile = true
          get "user/#{user1.id}", nil, {'X-AUTH-TOKEN' => session1.auth_token }

        end 

      end
      context "requester is a followee of user" do
      end
    end

    describe "user is public" do

    end

  end

end
