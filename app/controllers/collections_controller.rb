#coding: utf-8
class CollectionsController < ApplicationController
  before_action :signed_in_user#, only: [:new, :create, :update, :edit, :destroy]
  
  def new
    @user = current_user
    @debtor = Debtor.find_by_id(cookies[:current_debtor_id])
    @collection = Collection.new
  end
  
  def create
    @user = current_user
    #need to create a current_debtor or something
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
  
  def index
    @user = current_user
  end
  
  def show
    @user = current_user
    @debtor = Debtor.find_by_id(cookies[:current_debtor_id])
    @collections = @debtor.collections
  end
  
  # def update
  #   @user = current_user
  #   # @user = User.find(params[:id])
  #   if @collection.update_attributes(debtor_params)
  #     flash[:success] = "Informacion del deudor actualizada."
  #     redirect_to @collection
  #   else
  #     render 'edit'
  #   end
  # end

  
  private
    def collection_params
      if signed_in?
        params.require(:collection).permit(:amount_owed, :bounced_check_bank, 
                                            :bouncec_check_number, :notes, :internal_invoice_number)
      else
        redirect_to login_path
      end
    end

  
end
