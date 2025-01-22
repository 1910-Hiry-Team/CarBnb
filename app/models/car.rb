class Car < ApplicationRecord
  # GeoCoding
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  # Associations
  belongs_to :user
  has_many :bookings

  # Validations
  validates :address, presence: true
  # validates :address, format: { with: /[\w\s]+, [0-9]+, [\w\s]+, \w+, \w+$/i}
  # Format : Nom de rue, numéro, ville, code postal, pays
  # TODO: Revoir ce regex
  validates :price_per_hour, presence: true
  validates :category, presence: true
end
