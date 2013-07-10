class AddProfileIdToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :profile_id, :integer
  end
end
