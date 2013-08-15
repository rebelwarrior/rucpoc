class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def show
    @user = User.find(1)
  end
  
  def create
    @user = User.new(params[:user]) #not final implementatin
    if @user.save
      #handle successful save
    else
      render 'new'
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  
end
