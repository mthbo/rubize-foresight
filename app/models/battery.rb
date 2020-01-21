class Battery < ApplicationRecord
  belongs_to :user
  has_many :solar_systems

  scope :ordered, -> { order(:technology, :voltage, :capacity) }

  TECHNOLOGIES = [
    "Lead acid - Flooded / 0PzS",
    "Lead acid - Sealed GEL / 0PzV",
    "Lead acid - Sealed AGM",
    "Lithium"
  ]

  VOLTAGES = [2, 6, 12, 24]

  validates :technology, inclusion: {in: TECHNOLOGIES, allow_blank: true}, presence: true
  validates :dod, numericality: {greater_than: 0, less_than_or_equal_to: 100, allow_nil: true}, presence: true
  validates :efficiency, numericality: {greater_than: 0, less_than_or_equal_to: 100, allow_nil: true}, presence: true
  validates :voltage, inclusion: {in: VOLTAGES, allow_blank: true}, presence: true
  validates :capacity, numericality: {greater_than: 0, allow_nil: true}, presence: true

  monetize :price_min_cents, with_model_currency: :currency
  monetize :price_min_eur_cents, with_currency: :eur, allow_nil: true
  monetize :price_max_cents, with_model_currency: :currency
  monetize :price_max_eur_cents, with_currency: :eur, allow_nil: true

  before_save :set_prices_in_eur

  def storage_max
    voltage * capacity if (voltage and capacity)
  end

  def storage
    storage_max * dod.to_f / 100 if (storage_max and dod)
  end

  def name
    "#{technology} - #{voltage} V | #{capacity} Ah - #{storage_max} Wh"
  end

  private

  def set_prices_in_eur
    if currency and Money.default_bank.get_rate(currency, :EUR)
      self.price_min_eur_cents = price_min.exchange_to(:EUR).fractional if price_min
      self.price_max_eur_cents = price_max.exchange_to(:EUR).fractional if price_max
    end
  end

end
