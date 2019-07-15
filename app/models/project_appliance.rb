class ProjectAppliance < ApplicationRecord
  belongs_to :project
  belongs_to :appliance
  scope :ordered, -> { order(updated_at: :desc) }

  validates :quantity, numericality: {greater_than: 0}
end
