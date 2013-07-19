class User < ActiveRecord::Base
  rolify

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :authentication_keys => [:login]

  after_create :assign_default_role, :create_profile

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :username, :login, :name, :email, :password, :password_confirmation, :remember_me, :fully_registered, :avatar

  attr_accessor :login

  has_one :profile, dependent: :destroy
  
  has_many :hosted_appointments, foreign_key: "host_id", class_name: "Appointment"
  has_many :appointments, foreign_key: "attendee_id"

  has_many :reviews, foreign_key: "reviewee_id"
  has_many :reviewed_users, foreign_key: "reviewer_id", class_name: "Review", dependent: :destroy

  validates_attachment :avatar,
                          content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'] },
                          size: { less_than: 1.megabytes }

  validates :username, presence: true, uniqueness: true


  extend FriendlyId
  friendly_id :username, use: [:slugged, :history]

  has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }, default_url: 'https://s3.amazonaws.com/lorious/layout/elements/placeholders/image_placeholder.svg'


  def get_review_score
    reviews.average('rating').to_f
  end

  
    def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
    end

  ### This is the correct method you override with the code above
  ### def self.find_for_database_authentication(warden_conditions)
  ### end 

  protected
  
  # def confirmation_required?
  #   false
  # end

  def assign_default_role
    # Default Role: User, ID: 2
    add_role(:user)
  end

  def create_profile
    profile = Profile.new
    profile.user = self
    profile.fname = profile.first_name
    profile.lname = profile.last_name
    profile.display_name = profile.public_name
    profile.save

  end
  
end
