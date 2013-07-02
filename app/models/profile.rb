class Profile < ActiveRecord::Base
  attr_accessible :user_id, :email, :expertise, :expertise_hourly, :fname, :interest, :interest_hourly, :lname, :user_id, :niche
  validates :email, presence: true
  validates :fname, presence: true

belongs_to :user

has_many :requests

def name
  fname + " " + lname.to_s
end

end
