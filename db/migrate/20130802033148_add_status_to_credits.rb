class AddStatusToCredits < ActiveRecord::Migration
  def change
    add_column :credits, :status, :string
  end
end
