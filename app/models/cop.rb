class Cop < ActiveRecord::Base
  belongs_to :state
  belongs_to :city
  has_many :grievances

  before_save :generate_text_search

  private

  def generate_text_search
    text_search = []
    text_search << self.name
    text_search << self.badge_number
    self.text_search = I18n.transliterate(text_search.join(" ")).upcase.gsub(/[^0-9A-Z ]/, "")
  end
end
