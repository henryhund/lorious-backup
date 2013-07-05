class AddChatKeyToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :chat_key, :string
  end
end
