# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :card do
    user_id 1
    stripe_card_id "MyString"
  end
end
