class BookingsController < ApplicationController
  def index
    @bookings = Booking.all
  end

  def show
    @booking = Booking.find(params[:id])
  end

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user = current_user

    if @booking.save
      redirect_to user_booking_path(current_user)
    else
      render :new, unprocessable_entity
    end
  end

  def edit
    @booking = Booking.find(params[:id])
  end

  def update
    @booking = Booking.find(params[:id])
    @booking.update(booking_params)

    redirect_to user_booking_path(@booking), flash[:notice] = "Booking succesfully updated"
  end

  def destroy
    @booking.destroy
    redirect_to user_bookings_path(current_user), flash[:notice] = "Booking succesfully canceled"

  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:user_id, :car_id, :start_date, :end_date)
  end
end
