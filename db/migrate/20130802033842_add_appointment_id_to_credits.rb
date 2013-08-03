class AddAppointmentIdToCredits < ActiveRecord::Migration
  def change
    add_column :credits, :appointment_id, :integer
  end
end
