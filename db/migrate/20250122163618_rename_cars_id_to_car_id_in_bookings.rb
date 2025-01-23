class RenameCarsIdToCarIdInBookings < ActiveRecord::Migration[7.1]
  def change
    def change
      rename_column :bookings, :cars_id, :car_id
    end
  end
end
