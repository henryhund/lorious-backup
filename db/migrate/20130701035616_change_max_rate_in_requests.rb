class ChangeMaxRateInRequests < ActiveRecord::Migration
  def up
    change_column :requests, :max_rate, :decimal, :precision => 8, :scale => 2
  end

  def down
    change_column :requests, :max_rate, :string
  end
end
