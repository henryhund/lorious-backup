class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :appointment_id
      t.integer :reviewer_id
      t.integer :reviewee_id
      t.decimal :rating, precision: 2, scale: 1
      t.text :content

      t.timestamps
    end
    add_index :reviews, :appointment_id
    add_index :reviews, :reviewer_id
    add_index :reviews, :reviewee_id

    add_index :reviews, [:reviewer_id, :reviewee_id], unique: true

  end
end
