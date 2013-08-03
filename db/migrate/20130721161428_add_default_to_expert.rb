class AddDefaultToExpert < ActiveRecord::Migration
  def change
    change_column :users, :expert, :boolean, :default => false
  end
end
