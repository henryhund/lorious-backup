class Credit < ActiveRecord::Base
  attr_accessible :hash_id, :number, :transaction_id, :user_id, :status, :appointment_id

  belongs_to :user
  belongs_to :transaction
  belongs_to :appointment

end
