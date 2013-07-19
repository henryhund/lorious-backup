class Review < ActiveRecord::Base
  attr_accessible :appointment_id, :content, :rating, :reviewee_id, :reviewer_id
  validates :appointment_id, uniqueness: true
  validates :rating, presence: true
  validates :content, presence: true

  belongs_to :appointment

  belongs_to :reviewer, class_name: "User"
  belongs_to :reviewee, class_name: "User"

end
