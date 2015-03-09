class Wave < ActiveRecord::Base

  belongs_to :user  

  validates :title, length: {in: 1..30, message: "must be between 1 and 30 characters"}

  validates :description, length: {in: 1..100, message: "must be between 1 and 100 characters"}

  validates :place, length: {in:1..30, message: "must be between 1 and 30 characters"}
     
end
