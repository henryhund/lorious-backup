class Credit < ActiveRecord::Base
  attr_accessible :hash_id, :number, :transaction_id, :user_id

  belongs_to :user

end
