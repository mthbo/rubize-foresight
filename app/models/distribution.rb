class Distribution < ApplicationRecord
  has_many :solar_systems

  monetize :price_min_cents, with_model_currency: :currency
  monetize :price_min_eur_cents, with_currency: :eur, allow_nil: true

  monetize :price_max_cents, with_model_currency: :currency
  monetize :price_max_eur_cents, with_currency: :eur, allow_nil: true

  def price_min_eur_cents
    if price_min and Money.default_bank.get_rate(currency, :EUR)
      price_min.exchange_to(:EUR).fractional
    end
  end

  def price_max_eur_cents
    if price_max and Money.default_bank.get_rate(currency, :EUR)
      price_max.exchange_to(:EUR).fractional
    end
  end
end
