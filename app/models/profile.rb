class Profile < ActiveRecord::Base
  attr_accessible :user_id, :email, :expertise, :expertise_hourly, :fname, :lname, :niche, :tagline, :bio, :availability, :name_display_type, :privacy, :interest, :interest_hourly
  validates :email, presence: true
  validates :fname, presence: true
  after_save :do_update_user_name

  belongs_to :user

  has_many :requests

  def long_name
    fname + " " + lname.to_s
  end

  def short_name
    fname + " " + lname.to_s[0,1]
  end

  def name
    long_name
  end

  def public_name
    if self.name_display_type == "short"
      short_name
    elsif self.name_display_type == "long"
      long_name
    end
  end

  def private_name
  end

  private
    def do_update_user_name
      user = User.find(user_id)
      user.name = public_name
      user.save
    end

end
