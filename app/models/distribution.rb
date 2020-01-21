class Distribution < ApplicationRecord
  belongs_to :user
  has_many :solar_systems

  scope :persisted, -> { where.not(id: nil) }

  monetize :price_min_cents, with_model_currency: :currency
  monetize :price_min_eur_cents, with_currency: :eur, allow_nil: true
  monetize :price_max_cents, with_model_currency: :currency
  monetize :price_max_eur_cents, with_currency: :eur, allow_nil: true

  before_save :set_prices_in_eur

  private

  def set_prices_in_eur
    if currency and Money.default_bank.get_rate(currency, :EUR)
      self.price_min_eur_cents = price_min.exchange_to(:EUR).fractional if price_min
      self.price_max_eur_cents = price_max.exchange_to(:EUR).fractional if price_max
    end
  end
end
