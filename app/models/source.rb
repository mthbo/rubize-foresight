class Source < ApplicationRecord
  belongs_to :appliance

  validates :supplier, presence: true
  validates :issued_at, presence: true
  validates :country_code, presence: true, allow_blank: false
  validates :city, presence: true
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :currency, presence: true
  validates :discount_rate, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}

  monetize :price_cents, numericality: true, with_model_currency: :currency
  monetize :price_discount_cents, numericality: true, with_model_currency: :currency
  monetize :price_eur_cents, numericality: true, with_currency: :eur
  monetize :price_discount_eur_cents, numericality: true, with_currency: :eur

  def country_name
    if country_code
      country = ISO3166::Country[country_code]
      country.translations[I18n.locale.to_s] || country.name
    end
  end

  def price_discount_cents
    (price_cents * (1 - discount_rate.to_f / 100)).to_i if price_cents and discount_rate
  end

  def price_eur_cents
    price.exchange_to(:EUR).fractional if price
  end

  def price_discount_eur_cents
    price_discount.exchange_to(:EUR).fractional if price_discount
  end

end
