class Use < ApplicationRecord
  has_many :appliances
  validates :name, presence: true, uniqueness: true
end
