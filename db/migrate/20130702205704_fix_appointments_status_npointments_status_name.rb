class FixAppointmentsStatusNpointmentsStatusName < ActiveRecord::Migration
  def up
    rename_column :appointments, :status, :completed
  end

  def down
    rename_column :appointments, :completed, :status
  end
end
