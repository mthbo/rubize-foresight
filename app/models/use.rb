class Use < ApplicationRecord
  has_many :appliances, dependent: :nullify
  validates :name, presence: true, uniqueness: true
  scope :ordered, -> { left_joins(:appliances).group(:id).order('COUNT(appliances.id) DESC') }
end
