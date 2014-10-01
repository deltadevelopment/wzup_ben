# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :following do
    user
    association :followee, factory: :user
  end
end
