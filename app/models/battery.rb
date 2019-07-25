class Battery < ApplicationRecord
  has_many :power_supplies

  TECHNOLOGIES = [
    "Lead acid - Flooded / 0PzS",
    "Lead acid - Sealed GEL / 0PzV",
    "Lead acid - Sealed AGM",
    "Lithium"
  ]

  validates :technology, inclusion: {in: TECHNOLOGIES, allow_blank: true}, presence: true
  validates :dod, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_nil: true}, presence: true
  validates :efficiency, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_nil: true}, presence: true
  validates :voltage, numericality: {greater_than_or_equal_to: 0, allow_nil: true}, presence: true
  validates :capacity, numericality: {greater_than_or_equal_to: 0, allow_nil: true}, presence: true

  monetize :price_cents, with_model_currency: :currency
  monetize :price_eur_cents, with_currency: :eur, allow_nil: true

  def price_eur_cents
    if price and Money.default_bank.get_rate(currency, :EUR)
      price.exchange_to(:EUR).fractional
    end
  end

  def name
    "#{technology} - #{voltage} V | #{capacity} Ah"
  end

end
