class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def show
    @user = User.find(1)
  end
  
  def create
    @user = User.new(user_params) 
    if @user.save
      flash[:success] = "Bienvenido a RucPoc!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  
end
