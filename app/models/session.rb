class Session < ActiveRecord::Base
  belongs_to :user
  
  # TODO: Optimization: This is currently being checked both in #generate token, and here.
  validates :auth_token, uniqueness: true
  
  def generate_token(user_id)
    begin
      auth_token = SecureRandom.hex
    end while self.class.exists?(auth_token: auth_token)
    
    self.auth_token = auth_token
    self.user_id = user_id 
  end
end
