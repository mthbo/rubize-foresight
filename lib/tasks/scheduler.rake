namespace :open_exchange_rates do
  desc "Refresh rates from cache and update rates"
  task :refresh_rates => :environment do
    Money.default_bank.refresh_rates
    Money.default_bank.update_rates
  end
end

namespace :open_exchange_rates do
  desc "Update all prices of appliance sources in EUR"
  task :update_source_prices => :environment do
    Source.find_each do |source|
      if source.price and source.currency and Money.default_bank.get_rate(source.currency, :EUR)
        source.update(price_eur_cents: source.price.exchange_to(:EUR).fractional)
      end
    end
  end
end
