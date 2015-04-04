class Grievance < ActiveRecord::Base
  belongs_to :state
  belongs_to :city
  belongs_to :cop
  belongs_to :user
  belongs_to :revision, class_name: "Grievance", foreign_key: "revision_id"
  has_many :connected_grievance_associations
  has_many :connected_grievances, through: :connected_grievance_associations, source: "connected"

  validates_presence_of :city_name, :state_name, :cop_id, :date_incident, :title, :description, :user

  scope :visible, -> (user) do 
    result = where(is_revision: false)
    if user.present?
      if user.is_admin
        result
      else
        result.where("(visible = 'true') OR (user_id = ?)", user.id)
      end
    else
      result.where(visible: true)
    end
  end

  attr_accessor :connected_grievances_ids
  attr_accessor :cop_badge
  attr_accessor :cop_race

  after_initialize :default_values
  before_save :generate_text_search
  before_save :extract_names

  private

  def default_values
    self.date_incident ||= Date.today
    self.connected_grievances_ids ||= self.connected_grievances.pluck(:id).join(",")
  end

  def generate_text_search
    text_search = []
    text_search << self.id
    text_search << self.title
    text_search << self.description
    text_search << self.cop.try(:name)
    text_search << self.cop.try(:badge_number)
    text_search << self.state.try(:name)
    text_search << self.city.try(:name)
    text_search << self.date_incident.strftime("%m/%d/%Y")
    self.text_search = I18n.transliterate(text_search.join(" ")).upcase.gsub(/[^0-9A-Z ]/, "")
  end

  def extract_names
    self.cop_name = self.cop.try(:name) || ""
    self.city_name = self.city.try(:name) || ""
    self.state_name = self.state.try(:name) || ""
  end
end
