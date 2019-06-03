class Appliance < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, uniqueness: true
  mount_uploader :photo, PhotoUploader
  enum current_type: [:AC, :DC]
end
