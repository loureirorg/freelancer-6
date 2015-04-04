class User < ActiveRecord::Base
  has_many :grievances
  belongs_to :city
  belongs_to :state

  validates_presence_of :name, :email, :age, :race

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
end
