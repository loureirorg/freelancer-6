class AddNameRaceAgeToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :race, :string
    add_column :users, :age, :string
    add_column :users, :city_id, :integer
    add_column :users, :state_id, :integer
    add_column :users, :is_admin, :boolean
  end
end
