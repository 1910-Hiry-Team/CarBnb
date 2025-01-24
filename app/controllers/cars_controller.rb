class CarsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :search]
  before_action :set_car, only: [:show, :edit, :update, :destroy]
  def index
    @cars = policy_scope(Car)
  end

  def show
    @markers = [{
      lat: @car.latitude,
      lng: @car.longitude,
      info_window_html: render_to_string(partial: "info_window", locals: { car: @car }),
  }]
  end

  def new
    @car = Car.new
    authorize @car
  end

  def create
    @car = Car.new(car_params)
    @car.user = current_user
    authorize @car
    if @car.save

      redirect_to car_path(@car)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @car.update(car_params)
      redirect_to @car, notice: 'Car was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @car.destroy
    redirect_to cars_path, notice: 'Car was successfully destroyed.'
  end

  def search
    authorize Car
    Rails.logger.debug "Search Params: #{params.inspect}"

    # Start with all cars
    @cars = Car.all
    Rails.logger.debug "Initial Cars: #{@cars.inspect}"

    # Filter by car type
    if params[:car_type].present?
      @cars = @cars.where(category: params[:car_type])
      Rails.logger.debug "Filtered by car_type: #{@cars.inspect}"
    end

    # Filter by address and radius
    if params[:address].present? && params[:radius].present?
      begin
        @cars = @cars.near(params[:address], params[:radius].to_i)
        Rails.logger.debug "Filtered by address and radius: #{@cars.inspect}"
      rescue => e
        Rails.logger.error "Geocoding error: #{e.message}"
      end
    end

    # Filter by price range
    if params[:price_min].present? || params[:price_max].present?
      price_min = params[:price_min].to_i
      price_max = params[:price_max].to_i
      @cars = @cars.where(price_per_hour: price_min..price_max) if price_min > 0 || price_max > 0
      Rails.logger.debug "Filtered by price range: #{@cars.inspect}"
    end

    Rails.logger.debug "Final Cars: #{@cars.inspect}"

    # Render the index view with the filtered cars
    render :index
  end

  private

  def set_car
    @car = Car.find(params[:id])
    authorize @car
  end

  def car_params
    params.require(:car).permit(:address, :brand, :category, :model, :price_per_hour, photos: [])
  end
end
