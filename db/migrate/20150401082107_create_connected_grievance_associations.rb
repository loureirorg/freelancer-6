class CreateConnectedGrievanceAssociations < ActiveRecord::Migration
  def change
    create_table :connected_grievance_associations do |t|
      t.integer :grievance_id
      t.integer :connected_id

      t.timestamps null: false
    end
  end
end
