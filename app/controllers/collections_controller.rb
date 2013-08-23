#coding: utf-8
class CollectionsController < ApplicationController
  before_action :signed_in_user#, only: [:new, :create, :update, :edit, :destroy]
  
  def new
    @user = current_user
    @collection = Collection.new
  end
  
  def create
    @user = current_user
    #need to create a current_debtor or something
    @collection = debtor.collections.build(collection_params)
    # @collection = Collection.new(collection_params) 
    if @collection.save
      flash[:success] = "Nueva Factura Creada"
      redirect_to @collection
    else
      render 'new'
    end
  end
  
  def index
    @user = current_user
    # @collection = Collection.paginate(page: params[:page])
  end
  
  def show
    @user = current_user
    # @Collection = Debtor.collection.find(params[:id])
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
    def collections_params
      if signed_in?
        params.require(:collection).permit(:amount_owed)
      else
        redirect_to login_path
      end
    end

  
end
