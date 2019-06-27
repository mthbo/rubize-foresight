class Source < ApplicationRecord
  belongs_to :appliance
  scope :ordered, -> { order('issued_at DESC') }

  validates :supplier, presence: true
  validates :issued_at, presence: true
  validates :country_code, presence: true, inclusion: {in: ISO3166::Country.codes }
  validates :city, presence: true
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :currency, presence: true, inclusion: {in: Money::Currency }
  validates :discount_rate, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}

  monetize :price_cents, with_model_currency: :currency
  monetize :price_discount_cents, with_model_currency: :currency
  monetize :price_eur_cents, with_currency: :eur, allow_nil: true
  monetize :price_discount_eur_cents, with_currency: :eur, allow_nil: true

  def country_name
    if country_code
      country = ISO3166::Country[country_code]
      country.translations[I18n.locale.to_s] || country.name
    end
  end

  def price_discount_cents
    (price_cents * (1 - discount_rate.to_f / 100)).to_i if price_cents
  end

  def price_eur_cents
    if price and Money.default_bank.get_rate(currency, :EUR)
      price.exchange_to(:EUR).fractional
    end
  end

  def price_discount_eur_cents
    if price_discount and Money.default_bank.get_rate(currency, :EUR)
      price_discount.exchange_to(:EUR).fractional
    end
  end

end
