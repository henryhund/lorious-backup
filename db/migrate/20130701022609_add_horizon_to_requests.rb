class AddHorizonToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :horizon, :string
  end
end
