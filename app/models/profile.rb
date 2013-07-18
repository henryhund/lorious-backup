class Profile < ActiveRecord::Base
  attr_accessible :user_id, :email, :expertise, :display_name, :expertise_hourly, :fname, :lname, :niche, :tagline, :bio, :availability, :name_display_type, :privacy, :interest, :interest_hourly
  # validates :email, presence: true
  # validates :fname, presence: true
  # after_save :do_update_user_name

  belongs_to :user

  has_many :requests


  
  def long_name
    # self.fname + " " + self.lname.to_s
  end

  def short_name
    # self.fname + " " + self.lname.to_s[0,1]
  end

  # Lazy methods to get fname and lname sort of working
  def first_name
    name_array = self.user.name.split
    name_array[0]
  end

  def last_name
    name_array = self.user.name.split
    name_array[1]
  end

  def name
    long_name
  end

  def public_name
    if self.name_display_type == "short"
      first_name + " " + last_name.to_s[0,1] + "."
    elsif self.name_display_type == "long"
      first_name + " " + last_name.to_s
    end
  end

  def private_name
  end

  private
    # def do_update_user_name
    #   user = User.find(user_id)
    #   user.name = public_name
    #   user.save
    # end

end
