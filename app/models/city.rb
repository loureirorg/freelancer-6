class City < ActiveRecord::Base
  belongs_to :state
  has_many :cops
  has_many :grievances
  has_many :users
end
