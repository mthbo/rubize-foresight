class Use < ApplicationRecord
  has_many :appliances, dependent: :nullify
  validates :name, presence: true, uniqueness: true
end
