#coding: utf-8
class UsersController < ApplicationController
  before_action :signed_in_user,  only: [:index, :edit, :update]
  before_action :correct_user,    only:[:edit, :update]
  before_action :admin_user, only: :destroy
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params) 
    puts "================== #{current_user.inspect}  =========================="
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
      sign_in @user unless (current_user.admin or current_user.supervisor)
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Record del usuario borrado."
    redirect_to users_url
  end
  
  private
    def user_params
      if current_user.nil? or current_user.blank?
        params.require(:user).permit(:email, :password, :password_confirmation)
      elsif current_user.admin
        params.require(:user).permit(:email, :password, :password_confirmation, :supervisor)
      elsif current_user.supervisor
        params.require(:user).permit(:email, :password, :password_confirmation, :supervisor)
      else
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
    
    # Before filters
    
    # def signed_in_user
    #   unless signed_in?
    #     store_location
    #     redirect_to signin_url, notice: "Please log in." unless signed_in?
    #   end
    # end
    
    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user) or current_user.admin 
        redirect_to(login_url)
      end
    end
    
    def admin_user
      redirect_to(login_url) unless current_user.admin
    end
  
end
