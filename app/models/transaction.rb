class Transaction < ActiveRecord::Base
  attr_accessible :appointment_id, :status, :stripe_charge_id, :type, :user_id, :amount

  belongs_to :user
  belongs_to :appointment

  validates :stripe_charge_id, presence: true


end
