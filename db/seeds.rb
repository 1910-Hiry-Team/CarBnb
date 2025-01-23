# Set the starting variables
USER_COUNT = 100
CAR_COUNT = rand(50..100)
BOOKING_COUNT = rand(50..100)
CAR_PRICE_RANGE = 20..100
BOOKING_DAYS_FORWARD = 300
BOOKING_DURATION_RANGE = 1..7

# Set the methods used in the seeding
def select_valid_car(cars, users)
  booking_user = users.sample
  cars.reject { |car| car.user_id == booking_user.id }.sample
end

# Clean DB
cleaning_start_time = Time.now
puts "Cleaning the database..."
Booking.destroy_all
Car.destroy_all
User.destroy_all
puts "Database cleaned in #{Time.now - cleaning_start_time}s!"

seeding_start_time = Time.now

# Users
users_start_time = Time.now
puts "Creating users..."
users = USER_COUNT.times.map do
  # Create the users
  User.create!(
    email: Faker::Internet.unique.email,
    password: Faker::Internet.password,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name
  )
end
puts "Created #{User.count} users in #{Time.now - users_start_time}s"

# Cars
cars_start_time = Time.now
puts "Creating cars..."

cars = CAR_COUNT.times.map do
  car_brand = Faker::Vehicle.make
  car_model = begin
    Faker::Vehicle.model(make_of_model: car_brand)
  rescue
    Faker::Vehicle.model
  end
  # Create the cars
  Car.create!(
    address: "#{Faker::Address.full_address}",
    brand: car_brand,
    category: Faker::Vehicle.car_type,
    model: car_model,
    price_per_hour: rand(CAR_PRICE_RANGE),
    user: users.sample
  )
end
puts "Created #{Car.count} cars in #{Time.now - cars_start_time}s"

puts 'Attaching photos to existing cars...'
Car.all.each do |car|
  unless car.photos.attached? # Skip cars that already have photos attached
    car.photos.attach(
      [
        { io: File.open('/Users/joachimclodic/code/Jo8467/hiry-team-carbnb/app/assets/images/img1.jpg'), filename: 'img1.jpg', content_type: 'image/jpeg' },
        { io: File.open('/Users/joachimclodic/code/Jo8467/hiry-team-carbnb/app/assets/images/img2.jpg'), filename: 'img2.jpg', content_type: 'image/jpeg' }
      ]
    )
    puts "Attached photos to car ID #{car.id}"
  end
end
puts 'Finished attaching photos to existing cars.'

# Bookings
bookings_start_time = Time.now
puts "Creating bookings..."
BOOKING_COUNT.times do
  booking_car = select_valid_car(cars, users)
  next unless booking_car # Skip if no valid car is found

  booking_start_date = Faker::Date.forward(days: rand(BOOKING_DAYS_FORWARD))
  # Create the bookings
  Booking.create!(
    confirmed_booking: false,
    start_date: booking_start_date,
    end_date: Faker::Date.between(from: booking_start_date + BOOKING_DURATION_RANGE.min,
                                    to: booking_start_date + BOOKING_DURATION_RANGE.max),
    user: users.sample,
    car: booking_car
  )
end
puts "Created #{Booking.count} bookings in #{Time.now - bookings_start_time}s"

puts "Seeding complete! Created #{User.count} users, #{Car.count} cars and #{Booking.count} bookings in #{Time.now - seeding_start_time} seconds"
