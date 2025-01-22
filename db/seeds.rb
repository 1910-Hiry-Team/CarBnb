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

# Clear existing data to avoid duplication
Booking.destroy_all
Car.destroy_all
User.destroy_all

# Create Users
puts 'Creating users...'
users = []
5.times do |i|
  users << User.create!(
    email: "user#{i + 1}@example.com",
    password: 'password',
    password_confirmation: 'password'
  )
end

puts 'Created users:'
users.each { |user| puts "- #{user.email}" }

# Create Cars
puts 'Creating cars...'
car_categories = ['SUV', 'Sedan', 'Truck', 'Van']
addresses = [
  '123 Main Street, San Francisco, CA',
  '456 Oak Avenue, Los Angeles, CA',
  '789 Pine Lane, San Diego, CA',
  '321 Maple Road, Sacramento, CA',
  '654 Elm Street, Fresno, CA'
]

cars = []
users.each_with_index do |user, index|
  2.times do
    cars << Car.create!(
      address: addresses[index],
      brand: %w[Toyota Honda Ford Tesla].sample,
      category: car_categories.sample,
      model: %w[ModelX Civic F150 Corolla].sample,
      price_per_hour: rand(20..100),
      user: user
    )
  end
end

puts 'Created cars:'
cars.each { |car| puts "- #{car.brand} #{car.model} at #{car.address}" }

# Create Bookings
puts "Creating Booking DB seed"
Booking.create(confirmed_booking: false, start_date: "2025-01-10", end_date: "2025-01-20", user: User.first, car: Car.first)
Booking.create(confirmed_booking: false, start_date: "2025-01-08", end_date: "2025-01-10", user: User.first, car: Car.last)
Booking.create(confirmed_booking: false, start_date: "2024-12-15", end_date: "2024-12-16", user: User.first, car: Car.last)
Booking.create(confirmed_booking: false, start_date: "2024-12-05", end_date: "2024-12-12", user: User.first, car: Car.first)
Booking.create(confirmed_booking: false, start_date: "2024-11-21", end_date: "2024-11-24", user: User.last, car: Car.last)

puts "Seeding complete! Created #{User.count} users and #{Car.count} cars."