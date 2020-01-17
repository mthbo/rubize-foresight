class Source < ApplicationRecord
  belongs_to :appliance
  scope :ordered, -> { order('issued_at DESC') }

  validates :supplier, presence: true
  validates :issued_at, presence: true
  validates :country_code, presence: true, inclusion: {in: ISO3166::Country.codes }
  validates :city, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0}, presence: true
  validates :currency, inclusion: {in: Money::Currency }, presence: true
  validates :discount_rate, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}, presence: true

  monetize :price_cents, with_model_currency: :currency
  monetize :price_discount_cents, with_model_currency: :currency
  monetize :price_eur_cents, with_currency: :eur, allow_nil: true
  monetize :price_discount_eur_cents, with_currency: :eur, allow_nil: true

  before_save :set_price_in_eur

  def country_name
    if country_code
      country = ISO3166::Country[country_code]
      country.translations[I18n.locale.to_s] || country.name
    end
  end

  def price_discount_cents
    (price_cents * (1 - discount_rate.to_f / 100)).to_i if price_cents
  end

  def price_discount_eur_cents
    (price_eur_cents * (1 - discount_rate.to_f / 100)).to_i if price_eur_cents
  end

  private

  def set_price_in_eur
    if price and currency and Money.default_bank.get_rate(currency, :EUR)
      self.price_eur_cents = price.exchange_to(:EUR).fractional
    end
  end

end
