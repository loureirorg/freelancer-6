class State < ActiveRecord::Base
  has_many :cities
  has_many :cops
  has_many :grievances
  has_many :users
end
