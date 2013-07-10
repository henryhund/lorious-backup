class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :fname
      t.string :lname
      t.string :email
      t.string :expertise
      t.string :interest
      t.decimal :expertise_hourly, :precision => 8, :scale => 2
      t.decimal :interest_hourly, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
