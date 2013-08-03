class AddConffieldsToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :host_confirmed, :boolean, :default => false
    add_column :appointments, :attendee_confirmed, :boolean, :default => false
  end
end
