#utf-8

class UsersController < ApplicationController
  before_action :signed_in_user,  only: [:index, :edit, :update]
  before_action :correct_user,    only:[:edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params) 
    if @user.save
      sign_in @user
      flash[:success] = "Bienvenido a RucPoc!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    # now done w/ a before action
    # @user = User.find(params[:id])
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def update
    # @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Informacion del usuario actualizada."
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
    
    # Before filters
    
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please log in." unless signed_in?
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(login_url) unless current_user?(@user)
    end
  
end
