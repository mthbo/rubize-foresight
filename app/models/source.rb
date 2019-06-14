class Source < ApplicationRecord
  belongs_to :appliance

  validates :supplier, presence: true
  validates :issued_at, presence: true
  validates :country_code, presence: true, allow_blank: false
  validates :city, presence: true
  validates :amount_cents, presence: true
  validates :currency_code, presence: true
  validates :tax_rate, presence: true
end
