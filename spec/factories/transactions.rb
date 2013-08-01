# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    user_id 1
    appointment_id 1
    credit_id 1
    stripe_charge_id "MyString"
    type ""
    status "MyString"
  end
end
