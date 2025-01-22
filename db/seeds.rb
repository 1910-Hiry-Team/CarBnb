# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

USER_COUNT = 100
CAR_COUNT = rand(50..100)
BOOKING_COUNT = rand(50..100)

puts "Cleaning the database..."
Booking.destroy_all
Car.destroy_all
User.destroy_all
puts 'Database cleaned!'

puts "Creating users..."
users = USER_COUNT.times do
  User.create!(
    email: Faker::Internet.unique.email,
    password: Faker::Internet.password,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name
  )
end

puts "Creating cars..."
cars = CAR_COUNT.times do
  Car.create!(
    address: "#{Faker::Address.street_name}, #{rand(1000)}, #{Faker::Address.city},
              #{rand(10000)}, #{Faker::Address.country}",
    brand: Faker::Vehicle.manufacturer,
    category: Faker::Vehicle.car_type,
    model: Faker::Vehicle.model(make_of_model: :brand),
    price_per_hour: rand(20..100), # Random price between 20 and 100
    user: users.sample # Assign a random user
  )
end

puts "Creating bookings..."
BOOKING_COUNT.times do
  booking_user = users.sample
  available_cars = cars.reject { |car| car.user_id == booking_user.id } # Exclude cars owned by the booking user

  if available_cars.empty?
    raise "No cars available for booking that satisfy the condition!"
  end

  booking_car = available_cars.sample

  Booking.create!(
    confirmed_booking: false,
    start_date: Faker::Date.forward(days: rand(1..300)),
    end_date: Faker::Date.between(from: :start_date + 1, to: :start_date + rand(1..7)),
    user: users.sample,
    cars: booking_car
  )
end

puts "Seeding complete! Created #{User.count} users, #{Car.count} cars and #{Booking.count} bookings."
