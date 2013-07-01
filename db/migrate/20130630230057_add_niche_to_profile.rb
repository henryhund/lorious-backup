class AddNicheToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :niche, :string
  end
end
