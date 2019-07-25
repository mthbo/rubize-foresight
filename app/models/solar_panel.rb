class SolarPanel < ApplicationRecord

  TECHNOLOGIES = [
    "Polycristalline",
    "Monocristalline"
  ]

  validates :technology, inclusion: {in: TECHNOLOGIES, allow_blank: true}, presence: true
  validates :power, numericality: {greater_than_or_equal_to: 0, allow_nil: true}, presence: true
  validates :voltage, numericality: {greater_than_or_equal_to: 0, allow_nil: true}, presence: true

  monetize :price_cents, with_model_currency: :currency
  monetize :price_eur_cents, with_currency: :eur, allow_nil: true

  def price_eur_cents
    if price and Money.default_bank.get_rate(currency, :EUR)
      price.exchange_to(:EUR).fractional
    end
  end
end
