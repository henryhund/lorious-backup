class Appointment < ActiveRecord::Base
  attr_accessible :attendee_id, :host_id, :length, :completed, :time, :chat_key, :chat_session_id

  belongs_to :host, class_name: "User"
  belongs_to :attendee, class_name: "User"

  validates :host_id, presence: true
  validates :attendee_id, presence: true

  validates :chat_key, uniqueness: true

  has_one :review, foreign_key: "appointment_id", class_name: "Review"

  def review_host(rating, content)
    review = self.build_review(reviewer_id: attendee.id, reviewee_id: host.id, rating: rating, content: content)
    review.save
  end




end
