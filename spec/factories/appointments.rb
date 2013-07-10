# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :appointment do
    host_id 1
    attendee_id 1
    time "2013-07-02 16:35:20"
    status false
    length 1
  end
end
