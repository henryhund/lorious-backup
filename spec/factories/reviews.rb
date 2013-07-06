# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :review do
    appointment_id 1
    reviewer_id 1
    reviewee_id 1
    rating 1
    content "MyText"
  end
end
