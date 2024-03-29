class User < ActiveRecord::Base
  rolify

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :authentication_keys => [:login]
  devise :omniauthable, :omniauth_providers => [:google_oauth2]

  after_create :assign_default_role, :create_profile

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :username, :login, :name, :email, :password, :password_confirmation, :remember_me, :avatar, :expert, :avatar_remote_url
  attr_accessible :stripe_customer_id, :stripe_recipient_id


  attr_accessor :login

  has_one :profile, dependent: :destroy
  has_one :card, dependent: :destroy
  # has_one :bank_account, dependent: :destroy

  has_many :services, :dependent => :destroy
  has_many :credits
  has_many :transactions

  has_one :profile, :dependent => :destroy
  has_one :card, dependent: :destroy
  has_one :bank_account, dependent: :destroy
  
  has_many :hosted_appointments, foreign_key: "host_id", class_name: "Appointment"
  has_many :appointments, foreign_key: "attendee_id"

  has_many :reviews, foreign_key: "reviewee_id"
  has_many :reviewed_users, foreign_key: "reviewer_id", class_name: "Review", dependent: :destroy

  # validate :check_avatar, if: "!avatar.blank?"

  # def check_avatar
  #   errors.add(:base, "Photo must be a JPG, PNG or GIF file") if !['image/jpeg', 'image/jpg', 'image/png', 'image/gif'].include?(avatar.content_type)
  #   errors.add(:base, "Photo must be less than 2 megabytes") if avatar.size > 2048
  # end

  # validates_attachment_presence :avatar unless :avatar.nil?
  validates_attachment_content_type :avatar, content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'] unless :avatar.nil?
  validates_attachment_size :avatar, less_than: 2.megabytes, message: "Please upload a photo that is less than one megabyte." unless :avatar.nil?

  validates :username, presence: true, uniqueness: true
  validates :name, presence: true

  acts_as_messageable

  def mailboxer_email(object)
    #Check if an email should be sent for that object
    #if true
    return email
    #if false
    #return nil
  end

  extend FriendlyId
  friendly_id :username, use: [:slugged, :history]

  has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }, default_url: 'https://s3.amazonaws.com/lorious/layout/elements/placeholders/image_placeholder.jpg'


  def get_review_score
    reviews.average('rating').to_f
  end

# Credits Model
  def get_credits_total
    credits.sum('number').to_i
  end






  def avatar_remote_url=(url_value)
    url_value.gsub! /https/, 'http' unless url_value.blank?
    self.avatar = URI.parse(url_value) unless url_value.blank?
    # Assuming url_value is http://example.com/photos/face.png
    # avatar_file_name == "face.png"
    # avatar_content_type == "image/png"
    @avatar_remote_url = url_value
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

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    # print access_token.to_yaml
    # print data

    unless user
        user = User.create(name: data["name"],
             username: Devise.friendly_token[0,5],
             email: data["email"],
             password: Devise.friendly_token[0,20],
             avatar_remote_url: access_token["info"]["image"]
            )
        # Add Google Service (required)
        user.services.create(provider: access_token["provider"], uid: access_token["uid"], uname: access_token["info"]["name"], uemail: access_token["info"]["email"])
    end
    user
  end

  def first_name
    name.split[0]
  end

  def short_name
    unless name.split[1][0].nil?
      name.split[0] + " " + name.split[1][0] + "."
    else
      first_name
    end
  end


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
