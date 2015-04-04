class AddCopNameToGrievance < ActiveRecord::Migration
  def change
    add_column :grievances, :cop_name, :string
    add_column :grievances, :city_name, :string
    add_column :grievances, :state_name, :string
  end
end
