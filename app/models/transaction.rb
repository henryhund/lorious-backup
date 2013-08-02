class Transaction < ActiveRecord::Base
  attr_accessible :appointment_id, :status, :stripe_charge_id, :type, :user_id, :amount

  belongs_to :user
  belongs_to :appointment

  has_one :credit

  # validates :stripe_charge_id, presence: true


end
