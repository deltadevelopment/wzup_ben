FactoryGirl.define do
  factory :user do
    sequence(:username)  { |n| "Person#{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    phone_number '92837579'
    display_name 'jdoesilicious'
    availability 2 
    password 'jdoes123'
    password_salt '$2a$10$T.pUcjOLR/MKmE8PfNTrsu'
    password_hash '$2a$10$T.pUcjOLR/MKmE8PfNTrsu2RPVq7U7az1ve31.fsXYQiP1nF3tsSq'     
  end
end

