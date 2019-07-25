class PowerSystem < ApplicationRecord
  has_many :power_supplies

  validates :name, presence: true, uniqueness: true
  validates :power_out, numericality: {greater_than_or_equal_to: 0, allow_nil: true}, presence: true
  validates :charge_current, numericality: {greater_than_or_equal_to: 0, allow_nil: true}, presence: true
  validates :voltage_out_min, numericality: {greater_than_or_equal_to: 0, allow_nil: true}, presence: true
  validates :voltage_out_max, numericality: {greater_than_or_equal_to: 0, allow_nil: true}, presence: true
  validate :select_at_least_one_voltage

  monetize :price_cents, with_model_currency: :currency
  monetize :price_eur_cents, with_currency: :eur, allow_nil: true

  def select_at_least_one_voltage
    unless voltage_12? or voltage_24? or voltage_36? or voltage_48?
      errors.add(:voltage_48, "/ 36 / 24 / 12 must be selected")
    end
  end

  def price_eur_cents
    if price and Money.default_bank.get_rate(currency, :EUR)
      price.exchange_to(:EUR).fractional
    end
  end

  def charge_voltage
    voltages = ""
    voltages << (voltages.blank? ? "12" : "/12") if voltage_12?
    voltages << (voltages.blank? ? "24" : "/24") if voltage_24?
    voltages << (voltages.blank? ? "36" : "/36") if voltage_36?
    voltages << (voltages.blank? ? "48" : "/48") if voltage_48?
    voltages.present? ? (voltages << " V") : voltages = nil
    voltages
  end

  def voltage_range
    if voltage_out_min
      voltage_out_max ? "#{voltage_out_min} V - #{voltage_out_max} V" : "#{voltage_out_min} V"
    elsif voltage_out_max
      "#{voltage_out_max} V"
    else
      "n/a"
    end
  end

end
