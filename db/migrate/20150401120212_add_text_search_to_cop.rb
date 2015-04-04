class AddTextSearchToCop < ActiveRecord::Migration
  def change
    add_column :cops, :text_search, :text
  end
end
