class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.integer :appointment_id
      t.integer :credit_id
      t.string :stripe_charge_id
      t.string :transaction_type
      t.string :status

      t.timestamps
    end
  end
end
