class Profile < ActiveRecord::Base
  attr_accessible :email, :expertise, :expertise_hourly, :fname, :interest, :interest_hourly, :lname, :user_id, :niche
  validates :email, presence: true
  validates :fname, presence: true

has_many :requests

def name
  fname + " " + lname.to_s
end

end
