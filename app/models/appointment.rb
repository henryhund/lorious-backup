class Appointment < ActiveRecord::Base
  attr_accessible :attendee_id, :host_id, :length, :completed, :time, :chat_key, :chat_session_id

  belongs_to :host, class_name: "User"
  belongs_to :attendee, class_name: "User"

  validates :host_id, presence: true
  validates :attendee_id, presence: true

  validates :chat_key, uniqueness: true



end
