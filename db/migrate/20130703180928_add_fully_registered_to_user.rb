class AddFullyRegisteredToUser < ActiveRecord::Migration
  def change
    add_column :users, :fully_registered, :boolean, default: false
  end
end
