class CreateGrievances < ActiveRecord::Migration
  def change
    create_table :grievances do |t|
      t.integer :state_id
      t.integer :city_id
      t.integer :cop_id
      t.date :date_incident
      t.text :description
      t.integer :user_id
      t.boolean :publish_user_race
      t.boolean :publish_user_age
      t.boolean :visible
      t.boolean :is_new
      t.boolean :is_revision
      t.integer :revision_id

      t.timestamps null: false
    end
  end
end
