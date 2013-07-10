class AddChatSessiontoAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :chat_session_id, :string
  end
end
