class RenameTypeInRequests < ActiveRecord::Migration
  def up
    rename_column :requests, :type, :request_type
  end

  def down
    rename_column :requests, :request_type, :type
  end
end
