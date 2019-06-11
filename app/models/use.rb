class Use < ApplicationRecord
  has_many :appliances, dependent: :nullify
  validates :name, presence: true, uniqueness: true

  def appliances_ordered
    appliances.order("updated_at DESC")
  end
end
