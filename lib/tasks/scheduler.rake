namespace :open_exchange_rates do
  desc "Refresh rates from cache and update rates"
  task :refresh_rates => :environment do
    Money.default_bank.refresh_rates
    Money.default_bank.update_rates
  end
end

namespace :open_exchange_rates do
  desc "Update all prices of appliance sources in EUR"
  task :update_eur_prices => :environment do
    Source.find_each do |source|
      if source.price and source.currency and Money.default_bank.get_rate(source.currency, :EUR)
        source.update(price_eur_cents: source.price.exchange_to(:EUR).fractional)
      end
    end
    Battery.find_each do |battery|
      if battery.currency and Money.default_bank.get_rate(battery.currency, :EUR)
        battery.update(price_min_eur_cents: battery.price_min.exchange_to(:EUR).fractional) if battery.price_min
        battery.update(price_max_eur_cents: battery.price_max.exchange_to(:EUR).fractional) if battery.price_max
      end
    end
    CommunicationModule.find_each do |communication_module|
      if communication_module.currency and Money.default_bank.get_rate(communication_module.currency, :EUR)
        communication_module.update(price_min_eur_cents: communication_module.price_min.exchange_to(:EUR).fractional) if communication_module.price_min
        communication_module.update(price_max_eur_cents: communication_module.price_max.exchange_to(:EUR).fractional) if communication_module.price_max
      end
    end
    PowerSystem.find_each do |power_system|
      if power_system.currency and Money.default_bank.get_rate(power_system.currency, :EUR)
        power_system.update(price_min_eur_cents: power_system.price_min.exchange_to(:EUR).fractional) if power_system.price_min
        power_system.update(price_max_eur_cents: power_system.price_max.exchange_to(:EUR).fractional) if power_system.price_max
      end
    end
    SolarPanel.find_each do |solar_panel|
      if solar_panel.currency and Money.default_bank.get_rate(solar_panel.currency, :EUR)
        solar_panel.update(price_min_eur_cents: solar_panel.price_min.exchange_to(:EUR).fractional) if solar_panel.price_min
        solar_panel.update(price_max_eur_cents: solar_panel.price_max.exchange_to(:EUR).fractional) if solar_panel.price_max
      end
    end
    Project.find_each do |project|
      if project.currency and Money.default_bank.get_rate(project.currency, :EUR)
        project.update(diesel_price_eur_cents: project.diesel_price.exchange_to(:EUR).fractional) if project.diesel_price
        project.update(grid_connection_charge_eur_cents: project.grid_connection_charge.exchange_to(:EUR).fractional) if project.grid_connection_charge
        project.update(grid_subscription_charge_eur_cents: project.grid_subscription_charge.exchange_to(:EUR).fractional) if project.grid_subscription_charge
        project.update(grid_consumption_charge_eur_cents: project.grid_consumption_charge.exchange_to(:EUR).fractional) if project.grid_consumption_charge
      end
    end
  end
end
