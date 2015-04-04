class AddTitleToGrievance < ActiveRecord::Migration
  def change
    add_column :grievances, :title, :string
  end
end
