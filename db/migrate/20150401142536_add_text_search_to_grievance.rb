class AddTextSearchToGrievance < ActiveRecord::Migration
  def change
    add_column :grievances, :text_search, :text
  end
end
