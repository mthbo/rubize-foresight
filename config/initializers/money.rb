require 'money/bank/open_exchange_rates_bank'

MoneyRails.configure do |config|

  # To set the default currency
  #
  config.default_currency = :eur

  config.locale_backend = :i18n

  # Set default bank object
  #
  # Example:
  # config.default_bank = EuCentralBank.new

  oxr = Money::Bank::OpenExchangeRatesBank.new
  oxr.app_id = ENV['OXR_APP_ID']
  oxr.update_rates

  # (optional)
  # See https://github.com/spk/money-open-exchange-rates#cache for more info
  # Updated only when `refresh_rates` is called
  # oxr.cache = 'path/to/file/cache.json'

  # (optional)
  # Set the seconds after than the current rates are automatically expired
  # by default, they never expire, in this example 1 day.
  # This ttl is about money store (memory, database ...) passed though
  # `Money::Bank::OpenExchangeRatesBank` as argument not about `cache` option.
  # The base time is the timestamp fetched from API.
  # oxr.ttl_in_seconds = 86400

  # (optional)
  # Set historical date of the rate
  # see https://openexchangerates.org/documentation#historical-data
  # oxr.date = '2015-01-01'

  # (optional)
  # Set the base currency for all rates. By default, USD is used.
  # OpenExchangeRates only allows USD as base currency
  # for the free plan users.
  # oxr.source = 'USD'

  # (optional)
  # Extend returned values with alternative, black market and digital currency
  # rates. By default, false is used
  # see: https://docs.openexchangerates.org/docs/alternative-currencies
  # oxr.show_alternative = true

  # (optional)
  # Minified Response ('prettyprint')
  # see https://docs.openexchangerates.org/docs/prettyprint
  # oxr.prettyprint = false

  # (optional)
  # Refresh rates, store in cache and update rates
  # Should be used on crontab/worker/scheduler `Money.default_bank.refresh_rates`
  # If you are using unicorn-worker-killer gem or on Heroku like platform,
  # you should avoid to put this on the initializer of your Rails application,
  # because will increase your OXR API usage.
  # oxr.refresh_rates

  # (optional)
  # Force refresh rates cache and store on the fly when ttl is expired
  # This will slow down request on get_rate, so use at your on risk, if you don't
  # want to setup crontab/worker/scheduler for your application.
  # Again this is not safe with multiple servers and could increase API usage.
  # oxr.force_refresh_rate_on_expire = true

  config.default_bank = oxr


  # Add exchange rates to current money bank object.
  # (The conversion rate refers to one direction only)
  #
  # Example:
  # config.add_rate "USD", "CAD", 1.24515
  # config.add_rate "CAD", "USD", 0.803115

  # To handle the inclusion of validations for monetized fields
  # The default value is true
  #
  # config.include_validations = true

  # Default ActiveRecord migration configuration values for columns:
  #
  # config.amount_column = { prefix: '',           # column name prefix
  #                          postfix: '_cents',    # column name  postfix
  #                          column_name: nil,     # full column name (overrides prefix, postfix and accessor name)
  #                          type: :integer,       # column type
  #                          present: true,        # column will be created
  #                          null: false,          # other options will be treated as column options
  #                          default: 0
  #                        }
  #
  # config.currency_column = { prefix: '',
  #                            postfix: '_currency',
  #                            column_name: nil,
  #                            type: :string,
  #                            present: true,
  #                            null: false,
  #                            default: 'USD'
  #                          }

  # Register a custom currency
  #
  # Example:
  # config.register_currency = {
  #   priority:            1,
  #   iso_code:            "EU4",
  #   name:                "Euro with subunit of 4 digits",
  #   symbol:              "€",
  #   symbol_first:        true,
  #   subunit:             "Subcent",
  #   subunit_to_unit:     10000,
  #   thousands_separator: ".",
  #   decimal_mark:        ","
  # }

  # Specify a rounding mode
  # Any one of:
  #
  # BigDecimal::ROUND_UP,
  # BigDecimal::ROUND_DOWN,
  # BigDecimal::ROUND_HALF_UP,
  # BigDecimal::ROUND_HALF_DOWN,
  # BigDecimal::ROUND_HALF_EVEN,
  # BigDecimal::ROUND_CEILING,
  # BigDecimal::ROUND_FLOOR
  #
  # set to BigDecimal::ROUND_HALF_EVEN by default
  #
  # config.rounding_mode = BigDecimal::ROUND_HALF_UP

  # Set default money format globally.
  # Default value is nil meaning "ignore this option".
  # Example:
  #
  # config.default_format = {
  #   no_cents_if_whole: nil,
  #   symbol: nil,
  #   sign_before_symbol: nil
  # }
end
