class CreateCops < ActiveRecord::Migration
  def change
    create_table :cops do |t|
      t.integer :state_id
      t.integer :city_id
      t.string :name
      t.string :badge_number
      t.string :race

      t.timestamps null: false
    end
  end
end
