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
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  has_one :profile
  has_many :appointments, foreign_key: "host_id"
  has_many :appointments, foreign_key: "attendee_id"

  protected
  
  # def confirmation_required?
  #   false
  # end

  def assign_default_role
    # Default Role: User, ID: 2
    add_role(:user)
  end
  
end
