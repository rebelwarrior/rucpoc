class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      #redirect_back_or in controllers/hepers/sessions_helper.rb
      redirect_back_or user
    else
      flash.now[:error] = "Email y/o password invalido"
      render 'new'
    end
  end
  
  def destroy
    sign_out
    #redirect_to root_url
    redirect_to login_url
  end
  
end
