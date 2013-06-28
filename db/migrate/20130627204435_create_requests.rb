class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :name
      t.string :email
      t.string :expertise
      t.string :help_needed
      t.string :time_needed
      t.string :max_rate

      t.timestamps
    end
  end
end
