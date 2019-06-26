class Use < ApplicationRecord
  has_many :appliances, dependent: :nullify
  scope :ordered, -> { order(name: :asc) }

  DAY_TIME = 6
  NIGHT_TIME = 18
  RATES = {
    "1" => "10",
    "0.9" => "9",
    "0.8" => "8",
    "0.7" => "7",
    "0.6" => "6",
    "0.5" => "5",
    "0.4" => "4",
    "0.3" => "3",
    "0.2" => "2",
    "0.1" => "1"
  }

  validates :name, presence: true, uniqueness: true

  include PgSearch
  pg_search_scope :search,
    against: [ :name ],
    associated_against: {
      appliances: [ :name ]
    },
    using: {
      tsearch: { prefix: true }
    }
end
