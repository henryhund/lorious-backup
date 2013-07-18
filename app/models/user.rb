class User < ActiveRecord::Base
  rolify

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  after_create :assign_default_role

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :fully_registered, :avatar

  has_one :profile, dependent: :destroy
  
  has_many :appointments, foreign_key: "host_id"
  has_many :appointments, foreign_key: "attendee_id"

  has_many :reviews, foreign_key: "reviewee_id"
  has_many :reviewed_users, foreign_key: "reviewer_id", class_name: "Review"

  validates_attachment :avatar,
                          content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'] },
                          size: { less_than: 1.megabytes }




  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }, default_url: 'https://s3.amazonaws.com/lorious/layout/elements/placeholders/image_placeholder.svg'


  def get_review_score
    reviews.average('rating').to_f
  end

  protected
  
  # def confirmation_required?
  #   false
  # end

  def assign_default_role
    # Default Role: User, ID: 2
    add_role(:user)
  end
  
end
