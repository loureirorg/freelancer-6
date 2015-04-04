class AlterDefaultVisibleGrievance < ActiveRecord::Migration
  def change
    remove_column :grievances, :visible, :boolean
    add_column :grievances, :visible, :boolean, default: false
    remove_column :grievances, :is_new, :boolean
    add_column :grievances, :is_new, :boolean, default: true
    remove_column :grievances, :is_revision, :boolean
    add_column :grievances, :is_revision, :boolean, default: false
  end
end
