class CarsController < ApplicationController
  before_action :set_car, only: [:show, :edit, :update, :destroy]
  def index
    @car = Car.all
  end

  def show
  end

  def new
    @car = Car.new#
  end

  def create
    @car = Car.new(car_params)
    @car.user = current_user
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
    # @cars = Car.all
    # @cars = @cars.where(car_type: params[:car_type]) if params[:car_type].present?
    # @cars = @cars.near(params[:address], params[:radius]) if params[:address].present? && params[:radius].present?
    # if params[:price_min].present? && params[:price_max].present?
    #   @cars = @cars.where(price_per_hour: params[:price_min]..params[:price_max])
    # end
    # @cars = Car.all
    # Rails.logger.debug "Params: #{params.inspect}"

    if params[:car_type].present?
      @cars = @cars.where(category: params[:car_type])
      Rails.logger.debug "Filtered by car_type: #{@cars.inspect}"
    end

    if params[:address].present? && params[:radius].present?
      begin
        @cars = @cars.near(params[:address], params[:radius])
        Rails.logger.debug "Filtered by address and radius: #{@cars.inspect}"
      rescue => e
        Rails.logger.error "Geocoding error: #{e.message}"
      end
    end

    if params[:price_min].present? && params[:price_max].present?
      @cars = @cars.where(price_per_hour: params[:price_min]..params[:price_max])
      Rails.logger.debug "Filtered by price range: #{@cars.inspect}"
    end

    render :index
  end

  private

  def set_car
    @car = Car.find(params[:id])
  end

  def car_params
    params.require(:car).permit(:address, :brand, :category, :model, :price_per_hour)
  end
end
