class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  def index
    @bookings = Booking.where(user_id: params[:user_id])
  end

  def show
  end

  def new
    @user = User.find(params[:user_id])
    @car = Car.find(params[:car_id])
    @booking = Booking.new
  end

  def create
    start_date, end_date = params[:booking][:start_date].split(" to ")
    @booking = Booking.new(booking_params.merge(start_date: start_date, end_date: end_date))
    @booking.user = current_user
    @car = Car.find(params[:car_id])

    if @booking.save
      redirect_to user_bookings_path(current_user)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @car = Car.find(params[:car_id])
  end

  def update
    start_date, end_date = params[:booking][:start_date].split(" to ")
    @booking.update(booking_params.merge(start_date: start_date, end_date: end_date))
    redirect_to user_car_bookings_path(current_user), flash: { notice: "Booking succesfully updated" }
  end

  def destroy
    @booking.user = current_user
    @booking.destroy
    redirect_to user_bookings_path(current_user), flash: { notice: "Booking succesfully deleted" }, status: :see_other
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:user_id, :car_id, :start_date, :end_date)
  end
end
