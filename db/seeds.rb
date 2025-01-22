# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clean the database
puts 'cleaning the database...'
Car.destroy_all
User.destroy_all
puts 'database cleaned!'

# Create users
users = 10.times.map do |i|
  User.create!(
    email: "user#{i + 1}@example.com",
    password: "password",
    first_name: "First#{i + 1}",
    last_name: "Last#{i + 1}"
  )
end

# Create cars
10.times do |i|
  Car.create!(
    address: "Street #{i + 1}, #{i + 10}, City #{i + 1}, 12345, Country",
    brand: ["Toyota", "Honda", "Ford", "Chevrolet", "Tesla"].sample,
    category: ["SUV", "Sedan", "Truck", "Coupe", "Hatchback"].sample,
    model: "Model #{('A'..'Z').to_a.sample}",
    price_per_hour: rand(20..100), # Random price between 20 and 100
    user: users.sample # Assign a random user
  )
end

puts "Seeding complete! Created #{User.count} users and #{Car.count} cars."

puts "Cleaning the DB"
Booking.destroy_all

puts "Creating Booking DB seed"
Booking.create(confirmed_booking: false, start_date: "2025-01-10", end_date: "2025-01-20", user: User.first, car: Car.first)
Booking.create(confirmed_booking: false, start_date: "2025-01-08", end_date: "2025-01-10", user_id: 2)
Booking.create(confirmed_booking: false, start_date: "2024-12-15", end_date: "2024-12-16", user_id: 1)
Booking.create(confirmed_booking: false, start_date: "2024-12-05", end_date: "2024-12-12", user_id: 2)
Booking.create(confirmed_booking: false, start_date: "2024-11-21", end_date: "2024-11-24", user_id: 1)

puts "Seed DB created !"

# require 'faker'
# Fake Cars
# 10.times do
#   car = Car.new ("#{Faker::street_name}, #{rand(1000)}, #{Faker::Address.city},
#               #{rand(10000)}, #{Faker::Adress.country}",
#     address:
#     brand: Faker::Vehicle.manufacturer,
#     category: Faker::Vehicle.car_type,
#     model: Faker::Vehicle.model(make_of_model: :brand),
#     price_per_hour: rand(100)
#   )
#   car.save
# end
