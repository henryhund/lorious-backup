class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.integer :user_id
      t.integer :number
      t.integer :transaction_id
      t.string :hash_id

      t.timestamps
    end
  end
end
