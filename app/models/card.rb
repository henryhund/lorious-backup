class Card < ActiveRecord::Base
  attr_accessible :stripe_card_id, :user_id

  belongs_to :user

  validates :user_id, uniqueness: true 
end
