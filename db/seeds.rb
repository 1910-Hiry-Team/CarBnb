# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Cleaning the DB"
Booking.destroy_all

puts "Creating Booking DB seed"
Booking.create(confirmed_booking: false, start_date: "2025-01-10", end_date: "2025-01-20", user_id: 1)
Booking.create(confirmed_booking: false, start_date: "2025-01-08", end_date: "2025-01-10", user_id: 2)
Booking.create(confirmed_booking: false, start_date: "2024-12-15", end_date: "2024-12-16", user_id: 1)
Booking.create(confirmed_booking: false, start_date: "2024-12-05", end_date: "2024-12-12", user_id: 2)
Booking.create(confirmed_booking: false, start_date: "2024-11-21", end_date: "2024-11-24", user_id: 1)

puts "Seed DB created !"
