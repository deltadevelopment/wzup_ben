require 'rails_helper'

RSpec.describe "Users", :type => :request do

  describe "GET /user/id" do
    
    context "user is private" do

      context "requester is not a followee of user" do

        it "should return limited amount of data" do
          
        end 

      end
      context "requester is a followee of user" do
      end
    end

    describe "user is public" do

    end

  end

end
