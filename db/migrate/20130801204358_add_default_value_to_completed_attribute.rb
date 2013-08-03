class AddDefaultValueToCompletedAttribute < ActiveRecord::Migration
  def change
      change_column :appointments, :completed, :boolean, :default => false
  end
end
