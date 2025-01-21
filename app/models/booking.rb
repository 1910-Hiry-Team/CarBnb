class Booking < ApplicationRecord
  belongs_to :user

  validates :start_date, :end_date, :user_id, presence: true
end
