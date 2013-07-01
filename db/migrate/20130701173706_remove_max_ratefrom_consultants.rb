class RemoveMaxRatefromConsultants < ActiveRecord::Migration
  def up
    remove_column :requests, :max_rate
  end

  def down
    add_column :requests, :max_rate, :decimal, :precision => 8, :scale => 2
  end
end
