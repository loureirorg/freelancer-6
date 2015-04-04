json.array!(@grievances) do |grievance|
  json.extract! grievance, :id, :state_id, :city_id, :cop_id, :date_incident, :description, :user_id, :publish_user_race, :publish_user_age, :visible, :is_new, :is_revision, :revision_id
  json.url grievance_url(grievance, format: :json)
end
