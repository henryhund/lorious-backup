class AddFieldsToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :fee, :integer
    add_column :appointments, :conversation_id, :integer
    add_column :appointments, :status, :string
  end
end
