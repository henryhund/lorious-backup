class AddMaxRatefromRequests < ActiveRecord::Migration
  def up
    add_column :requests, :max_rate, :decimal, :precision => 8, :scale => 2
  end

  def down
    remove_column :requests, :max_rate
  end
end
