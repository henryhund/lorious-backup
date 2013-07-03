class Appointment < ActiveRecord::Base
  attr_accessible :attendee_id, :host_id, :length, :completed, :time

  belongs_to :host, class_name: "User"
  belongs_to :attendee, class_name: "User"

  validates :host_id, presence: true
  validates :attendee_id, presence: true

end
