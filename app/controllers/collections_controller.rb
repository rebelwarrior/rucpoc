#coding: utf-8
class CollectionsController < ApplicationController
  before_action :signed_in_user
  
  def new
    @user = current_user
    redirect_to debtors_path if cookies[:current_debtor_id].nil?
    @debtor = Debtor.find_by_id(cookies[:current_debtor_id])
    @collection = Collection.new
  end
  
  def create
    @user = current_user
    debtor = Debtor.find_by_id(cookies[:current_debtor_id])
    @collection = debtor.collections.build(collection_params)
    # @collection = Collection.new(collection_params) 
    if @collection.save
      flash[:success] = "Nueva Factura Creada"
      redirect_to @collection
    else
      flash[:error] = "Factura no gravada"
      render 'new'
    end
  end
  
  def edit
    @user = current_user
    redirect_to debtors_path if cookies[:current_debtor_id].nil?
    debtor = Debtor.find_by_id(cookies[:current_debtor_id])
    @collection = Collection.find_by_id(params[:id])
  end
  
  def update
    @user = current_user
    redirect_to debtors_path if cookies[:current_debtor_id].nil? or params[:id].nil?
    debtor = Debtor.find_by_id(cookies[:current_debtor_id])
    # @collection = debtor.collections #.build(collection_params) #erroring out
    # @collection = Collection.new(collection_params) 
    @collection = Collection.find_by_id(params[:id])
    # && @collection.update_attribute(:paid?, true)
    if @collection.update_attributes(collection_params) && @collection.valid?
      flash[:success] = "Factura Actualizada"
      redirect_to @collection
    else
      flash[:error] = "Factura no actualizada"
      render 'edit'
    end
  end
  
  def index
    @user = current_user
  end
  
  def show
    @user = current_user
    @debtor = Debtor.find_by_id(cookies[:current_debtor_id])
    @collection = Collection.find_by_id(params[:id])
    @collections = @debtor.collections
  end
  
  def destroy
    @user = current_user
    if current_user.admin? or current_user.supervisor?
      #Should only be certain users --> Supervisor users.
      @debtor = Debtor.find_by_id(cookies[:current_debtor_id])
      @debtor.collections.find(params[:id]).destroy
      flash[:success] = "Factura borrada."
      redirect_to collection_url
    else
      flash.now![:error] = "Solo Administradores y Supervisores pueden borrar la factura."
    end
  end

  
  private
    def collection_params
      if signed_in?
        if current_user.admin or current_user.supervisor
          params.require(:collection).permit(:amount_owed, :bounced_check_bank, :bounced_check_number, 
                                            :notes, :internal_invoice_number, :being_processed, :paid)
        else
          params.require(:collection).permit(:amount_owed, :bounced_check_bank, 
                                            :bounced_check_number, :notes, :internal_invoice_number)
        end
      else
        redirect_to login_path
      end
    end

    def current_debtor
      unless cookies[:current_debtor_id].nil?
        Debtor.find_by_id(cookies[:current_debtor_id])
      end
    end
      
  
end
