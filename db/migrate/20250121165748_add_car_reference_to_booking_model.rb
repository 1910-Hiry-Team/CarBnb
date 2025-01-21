class AddCarReferenceToBookingModel < ActiveRecord::Migration[7.1]
  def change
    add_reference :bookings, :cars
  end
end
