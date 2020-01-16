namespace :open_exchange_rates do
  desc "Refresh rates from cache and update rates"
  task :refresh_rates => :environment do
    Money.default_bank.refresh_rates
    Money.default_bank.update_rates
  end
end
