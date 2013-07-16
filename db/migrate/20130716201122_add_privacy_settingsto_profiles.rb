class AddPrivacySettingstoProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :privacy, :string, default: "private"
    add_column :profiles, :name_display_type, :string, default: "long"
  end
end
