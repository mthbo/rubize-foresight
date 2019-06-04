class Appliance < ApplicationRecord
  belongs_to :user
  belongs_to :use

  mount_uploader :photo, PhotoUploader

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :voltage, presence: true
  validates :power, presence: true

  enum current_type: [:AC, :DC]

  RATES = [1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0]
end
