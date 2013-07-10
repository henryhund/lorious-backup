# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    user_id 1
    fname "MyString"
    lname "MyString"
    email "MyString"
    expertise "MyString"
    interest "MyString"
    expertise_hourly "9.99"
    interest_hourly "9.99"
  end
end
