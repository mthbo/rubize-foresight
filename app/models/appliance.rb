class Appliance < ApplicationRecord
  belongs_to :user
  belongs_to :use

  mount_uploader :photo, PhotoUploader

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :voltage, presence: true
  validates :power, presence: true
  validates :power_factor, presence: true
  validates :starting_coefficient, presence: true
  validates :current_type, presence: true

  TYPES = ["AC", "DC"]
  # RATES = [1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1]
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
  # RATES = ["1", "0.9", "0.8", "0.7", "0.6", "0.5", "0.4", "0.3", "0.2", "0.1"]
end
