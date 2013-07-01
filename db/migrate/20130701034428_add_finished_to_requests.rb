class AddFinishedToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :finished, :boolean
  end
end
