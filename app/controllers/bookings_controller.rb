class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  def index
    @bookings = policy_scope(Booking) # Booking.where(user_id: params[:user_id])
  end

  def show
  end

  def new
    @user = User.find(params[:user_id])
    @car = Car.find(params[:car_id])
    @booking = Booking.new
    authorize @booking
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user = current_user
    @car = Car.find(params[:car_id])
    authorize @booking
    if @booking.save
      redirect_to user_bookings_path(current_user)
    else
      render :new, unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @car = Car.find(params[:car_id])
  end

  def update
    @booking.update(booking_params)
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
    authorize @booking
  end

  def booking_params
    params.require(:booking).permit(:user_id, :car_id, :start_date, :end_date)
  end
end
