class Session < ActiveRecord::Base
  belongs_to :user
  
  def generate_token(user_id)
    self.auth_token = SecureRandom.hex
    self.user_id = user_id 
  end
end
