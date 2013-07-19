class DeleteIndexFromReviews < ActiveRecord::Migration
  def change
    remove_index "reviews", :name=> "index_reviews_on_reviewer_id_and_reviewee_id"
  end
end
