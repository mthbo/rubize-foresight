class Project < ApplicationRecord

  scope :ordered, -> { order(updated_at: :desc) }

  include PgSearch
  pg_search_scope :search,
    against: [ :name ],
    using: {
      tsearch: {
        prefix: true,
        dictionary: "english",
        any_word: true
      }
    }

  FREQUENCIES = ["50 Hz", "60 Hz"]

  validates :name, presence: true, uniqueness: true
  validates :country_code, presence: true, inclusion: {in: ISO3166::Country.codes }
  validates :city, presence: true
  validates :day_time, presence: true
  validates :night_time, presence: true
  validates :voltage_min, numericality: {greater_than_or_equal_to: 0}, allow_nil: true
  validates :voltage_max, numericality: {greater_than_or_equal_to: 0}, allow_nil: true
  validates :frequency, inclusion: {in: FREQUENCIES, allow_blank: true}
  validate :select_at_least_one_current_type

  def select_at_least_one_current_type
    unless current_ac? or current_dc?
      errors.add(:current_dc, "or ac must be selected")
    end
  end

  def country_name
    if country_code
      country = ISO3166::Country[country_code]
      country.translations[I18n.locale.to_s] || country.name
    end
  end
end
