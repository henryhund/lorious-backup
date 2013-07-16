class SessionRecord < ActiveRecord::Base
  attr_accessible :chat_session_id, :disconnected_at, :user_id_1, :user_id_2

  belongs_to :appointment

end
