class Status < ActiveRecord::Base
  
  belongs_to :user, dependent: :destroy

  attr_accessor :media_url

  validates :body, length: { in: 1..140, allow_nil: false, message: "must be between 1 and 140 characters"} 

end
