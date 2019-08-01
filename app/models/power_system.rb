class PowerSystem < ApplicationRecord
  has_many :solar_systems

  VOLTAGES = [24, 48]

  validates :name, presence: true, uniqueness: true
  validates :system_voltage, inclusion: {in: VOLTAGES, allow_blank: true}, presence: true
  validates :power_in_min, numericality: {greater_than_or_equal_to: 0, allow_nil: true}, presence: true
  validates :power_in_max, numericality: {greater_than_or_equal_to: 0, allow_nil: true}, presence: true
  validates :power_out_max, numericality: {greater_than_or_equal_to: 0, allow_nil: true}, presence: true
  validates :voltage_out_min, numericality: {greater_than_or_equal_to: 0, allow_nil: true}, presence: true
  validates :voltage_out_max, numericality: {greater_than_or_equal_to: 0, allow_nil: true}, presence: true

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

  def output
    ac_out? ? "AC" : "DC"
  end

  def voltage_range
    if voltage_out_min
      voltage_out_max ? "#{voltage_out_min} - #{voltage_out_max} V" : "#{voltage_out_min} V"
    elsif voltage_out_max
      "#{voltage_out_max} V"
    else
      "n/a"
    end
  end

end
