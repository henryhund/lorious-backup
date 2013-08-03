class Appointment < ActiveRecord::Base
  attr_accessible :attendee_id, :host_id, :length, :completed, :time, :chat_key, :chat_session_id, :fee, :host_confirmed, :attendee_confirmed

  belongs_to :host, class_name: "User"
  belongs_to :attendee, class_name: "User"

  validates :host_id, presence: true
  validates :attendee_id, presence: true
  validates :time, presence: true
  validates :length, presence: true

  validates :chat_key, uniqueness: true

  has_one :credit
  has_one :review, foreign_key: "appointment_id", class_name: "Review"
  has_many :session_records, primary_key: "chat_session_id", foreign_key: "chat_session_id"

  has_one :transaction
  has_one :conversation

  def review_host(rating, content)
    review = self.build_review(reviewer_id: attendee.id, reviewee_id: host.id, rating: rating, content: content)
    review.save
  end

  def status
    self.attendee_confirmed && self.host_confirmed
  end

  def calculate_length
    records = self.session_records
    length = 0

    if records
      records.each do | record |
        length += record.disconnected_at - record.created_at unless record.disconnected_at.nil?
      end
    end

    length / 60

  end

end
