class DefaultPublishGrievance < ActiveRecord::Migration
  def change
    remove_column :grievances, :publish_user_race, :boolean
    remove_column :grievances, :publish_user_age, :boolean
    add_column :grievances, :publish_user_race, :boolean, default: true
    add_column :grievances, :publish_user_age, :boolean, default: true
  end
end
