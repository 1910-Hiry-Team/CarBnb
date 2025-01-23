module CarsHelper
  def user_owns_car?(user)
    user.cars.exists?
  end
end
