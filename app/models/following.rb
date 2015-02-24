class Following < ActiveRecord::Base
  
  belongs_to :user, dependent: :destroy
  belongs_to :followee, class_name: 'User', dependent: :destroy

end
