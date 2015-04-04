class ConnectedGrievanceAssociation < ActiveRecord::Base
  belongs_to :grievance
  belongs_to :connected, class_name: "Grievance"
end
