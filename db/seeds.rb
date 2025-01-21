# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end



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
