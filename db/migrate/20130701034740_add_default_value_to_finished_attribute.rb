class AddDefaultValueToFinishedAttribute < ActiveRecord::Migration
  def change
    change_column :requests, :finished, :boolean, :default => false
  end
end
