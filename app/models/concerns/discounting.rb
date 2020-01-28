module Discounting
  extend ActiveSupport::Concern

  included do
    FINANCE = {
      discount_rate: 0.1,
      years: 15
    }
  end

  def capex_discounted(capex, lifetime)
    discounted_cost = capex
    replacement_year = lifetime
    while replacement_year < FINANCE[:years]
      discounted_cost += capex.to_f / ((1 + FINANCE[:discount_rate]) ** replacement_year )
      replacement_year += lifetime
    end
    salvage_cost = capex * (replacement_year - FINANCE[:years]) / lifetime
    discounted_cost -= salvage_cost.to_f / ((1 + FINANCE[:discount_rate]) ** FINANCE[:years] )
    discounted_cost
  end

  def opex_discounted(opex)
    (1..FINANCE[:years]).reduce(0) { |discounted_cost, year| discounted_cost + (opex).to_f / ((1 + FINANCE[:discount_rate]) ** year ) }
  end

  def energy_discounted(energy)
    (1..FINANCE[:years]).reduce(0) { |discounted_energy, year| discounted_energy + energy.to_f / ((1 + FINANCE[:discount_rate]) ** year ) }
  end
end
