# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :credit do
    user_id 1
    number 1
    transaction_id 1
    hash "MyString"
  end
end
