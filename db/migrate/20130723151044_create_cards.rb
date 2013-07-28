class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :user_id
      t.string :stripe_card_id

      t.timestamps
    end
    add_index :cards, :user_id
  end
end
