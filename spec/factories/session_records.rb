# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :session_record do
    chat_session_id "MyString"
    user_id_1 1
    user_id_2 1
    disconnected_at "2013-07-16 10:51:54"
  end
end
