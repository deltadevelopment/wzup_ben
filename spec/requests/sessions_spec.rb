require 'rails_helper'

RSpec.describe SessionsController, :type => :request do
  let(:user) { FactoryGirl.create(:user) }
 describe 'authenticate' do
   it "should return bad credentials when no user/password match found" do
     error = %({"error":"Bad credentials"})

     post '/login', :username =>  user.username, :password =>  'bad'
     expect(response.body).to be_json_eql(error)
   end
   it "should return success and auth token in json" do
     params = {:username => user.username, :password => user.password}
     success = %({"success":"User was logged in"})

     post '/login', params
     expect(response.body).to be_json_eql(success).excluding("auth_token")
   end
  end
 describe 'logout' do
   it "should return session wasn't found" do
     error = %({"error": "Session could not be found"})

     delete '/login', :auth_token => "wrong"
     expect(response.body).to be_json_eql(error)
   end
   it "should return 'user was logged out' when destroy" do
     success = %({"success":"User was logged out"})

     post '/login', :username => user.username, :password => user.password
     auth_token = JSON.parse(response.body)["auth_token"]
     delete '/login', :auth_token => auth_token 
     expect(response.body).to be_json_eql(success)
   end
 end

 end

