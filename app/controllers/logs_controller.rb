class LogsController < ApplicationController
  before_action :signed_in_user
  
  def new
    @user = current_user
    redirect_to debtors_path if cookies[:current_debtor_id].nil?
    @collection = Collection.find_by_id(params[:collection_id])
    @debtor = Debtor.find_by_id(@collection.debtor_id)
    @log = Log.new(:collection => @collection)
    # @log = @collection.logs.build
  end
  
  def create
    @user = current_user
    # debtor = Debtor.find_by_id(cookies[:current_debtor_id])
    collection = Collection.find_by_id(params[:collection_id])
    # @log = Log.new(log_params) 
    @log = collection.logs.build(params[:log])
    # @collection.log.build(params[:log])
    if @log.save
      flash[:success] = "Nueva Factura Creada"
      redirect_to @log
    else
      flash[:error] = "Factura no gravada"
      render 'new'
    end
    
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
