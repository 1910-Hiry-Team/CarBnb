puts 'How heavy do you want the seeding to be? (light/medium/heavy)'
  seeding_type = gets.chomp

  if seeding_type =~ /\b(light|l)\b/i
    puts 'Light seeding selected.'
  elsif seeding_type =~ /\b(medium|m)\b/i
    puts 'Medium seeding selected.'
  elsif seeding_type =~ /\b(heavy|h)\b/i
    puts 'Heavy seeding selected.'
  else
    puts 'Invalid input. Defaulting to light seeding.'
    seeding_type = 'light'
  end

  if seeding_type =~ /\b(heavy|h)\b/i
    puts 'WARNING: Heavy seeding may take a long time to complete. Are you sure you want to proceed? (yes/no)'
    puts 'Estimated time: 5-10 minutes'
    proceed = gets.chomp
    unless proceed =~ /\b(yes|y)\b/i
      puts 'Seeding cancelled.'
      exit
    end
  end

  # Set the seeding variables
  if seeding_type =~ /\b(light|l)\b/i
    USER_COUNT = 10
    CAR_COUNT = rand(5..10)
    BOOKING_COUNT = rand(5..10)
    CAR_PRICE_RANGE = 20..100
    BOOKING_DAYS_FORWARD = 30
    BOOKING_DURATION_RANGE = 1..7
  elsif seeding_type =~ /\b(medium|m)\b/i
    USER_COUNT = 100
    CAR_COUNT = rand(50..100)
    BOOKING_COUNT = rand(50..100)
    CAR_PRICE_RANGE = 20..100
    BOOKING_DAYS_FORWARD = 100
    BOOKING_DURATION_RANGE = 1..7
  elsif seeding_type =~ /\b(heavy|h)\b/i
    USER_COUNT = 1000
    CAR_COUNT = rand(500..1000)
    BOOKING_COUNT = rand(500..1000)
    CAR_PRICE_RANGE = 20..100
    BOOKING_DAYS_FORWARD = 300
    BOOKING_DURATION_RANGE = 1..7
  end

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
  rand_img_nb = rand(1..7)
  rand_img_name = "img#{rand_img_nb}.jpg"
  unless car.photos.attached? # Skip cars that already have photos attached
    car.photos.attach(
      [
        { io: File.open("app/assets/images/#{rand_img_name}"),
          filename: rand_img_name,
          content_type: 'image/jpeg' },
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
