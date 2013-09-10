class LogsController < ApplicationController
  before_action :signed_in_user
  
  def new
    @user = current_user
    redirect_to debtors_path if cookies[:current_debtor_id].nil?
    @debtor = Debtor.find_by_id(cookies[:current_debtor_id])
    @collection = Collection.find_by_id(params[:id])
    @log = Log.new
  end
  
  def create
    @user = current_user
    debtor = Debtor.find_by_id(cookies[:current_debtor_id])
    # @log = Log.new(log_params) 
    # @log = debtor.collections.log.build(log_params)????
    
  end
  
  def show
    @user = current_user
    
  end
  
  def destroy
    @user = current_user
    if current_user.admin?
      #Should only be certain users --> Supervisor users.
      @debtor = Debtor.find_by_id(cookies[:current_debtor_id])
      @debtor.collections.logs.find(params[:id]).destroy
      flash[:success] = "Bitacora borrada."
      redirect_to collection_url
    else
      flash.now![:error] = "Solo Administradores pueden borrar la bitacora."
    end
  end
  
end
