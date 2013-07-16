class Appointment < ActiveRecord::Base
  attr_accessible :attendee_id, :host_id, :length, :completed, :time, :chat_key, :chat_session_id

  belongs_to :host, class_name: "User"
  belongs_to :attendee, class_name: "User"

  validates :host_id, presence: true
  validates :attendee_id, presence: true

  validates :chat_key, uniqueness: true

  has_one :review, foreign_key: "appointment_id", class_name: "Review"
  has_many :session_records, primary_key: "chat_session_id", foreign_key: "chat_session_id"

  def review_host(rating, content)
    review = self.build_review(reviewer_id: attendee.id, reviewee_id: host.id, rating: rating, content: content)
    review.save
  end

  def calculate_length
    records = self.session_records
    length = 0

    if records
      records.each do | record |
        length += record.disconnected_at - record.created_at
      end
    end

    length / 60

  end


end
