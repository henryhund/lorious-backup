class AddTypeToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :type, :string
  end
end
