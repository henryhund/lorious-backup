class AddFieldsToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :tagline, :string
    add_column :profiles, :bio, :text
    add_column :profiles, :availability, :string
  end
end
