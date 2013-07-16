class CreateSessionRecords < ActiveRecord::Migration
  def change
    create_table :session_records do |t|
      t.string :chat_session_id
      t.integer :user_id_1
      t.integer :user_id_2
      t.datetime :disconnected_at

      t.timestamps
    end
  end
end
