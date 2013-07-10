class ChangeRatingToDecimalInReviews < ActiveRecord::Migration
  def up
    change_column :reviews, :rating, :decimal, precision: 2, scale: 1
  end

  def down
    change_column :reviews, :rating, :integer
  end
end
