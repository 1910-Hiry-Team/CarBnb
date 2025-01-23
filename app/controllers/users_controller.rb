class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  # def new
  #   @user = User.new
  # end

  # private
  # def set_user
  #   @user = User.find(params[:id])
  # end

  # def user_params
  #   params.require(:user).permit(:name, :email)
  # end
end
