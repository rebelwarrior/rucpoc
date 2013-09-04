#coding: utf-8
class DebtorsController < ApplicationController
  before_action :signed_in_user#, only: [:new, :create, :update, :edit, :destroy]
  
  def new
    @user = current_user
    @debtor = Debtor.new
  end
  
  def create
    @user = current_user
    @debtor = Debtor.new(debtor_params) 
    if @debtor.save
      flash[:success] = "Nuevo Record de Deudor Creado."
      redirect_to @debtor
    else
      render 'new'
    end
  end
  
  def edit
    @user = current_user
    @debtor = Debtor.find(params[:id])
    cookies[:current_debtor_id] = @debtor.id
    # now done w/ a before action
    # @user = User.find(params[:id])
  end
  
  def search
    @debtor = Debtor.search(params[:search])
  end
  
  def index
    @user = current_user
    @debtors = params[:search].nil? ? Debtor.paginate(page: params[:page]) : Debtor.search(params[:search])
    #map is an alias of collect, reduce of inject and select of find_all
    @color_code_proc = ->(debtor){debtor.collections.collect do |invoice|
        invoice.amount_owed unless invoice.paid? #or invoice.inprocess
      end.reduce do |amount, total|
        amount = amount.nil? ? 0 : amount
        total + amount
      end }
  end
  
  def show
    @user = current_user
    @debtor = Debtor.find(params[:id])
    cookies[:current_debtor_id] = @debtor.id
    @collections = @debtor.collections.paginate(page: params[:page])
  end
  
  def update
    @user = current_user
    # @user = User.find(params[:id])
    @debtor = Debtor.find(cookies[:current_debtor_id])
    if @debtor.update_attributes(debtor_params)
      flash[:success] = "Informacion del deudor actualizada."
      redirect_to @debtor
    else
      render 'edit'
    end
  end
  
  def destroy
    @user = current_user
    #Should only be certain users --> Supervisor users.
    Debtor.find(params[:id]).destroy
    flash[:success] = "Record del deudor borrado."
    redirect_to debtors_url
  end
  
  private
    def debtor_params
      if signed_in?
        params.require(:debtor).permit(:name, :email, :tel, :address,
                                        :location, :contact_person, :employer_id_number)
      else
        redirect_to login_path
      end
    end
  
  
  # def create
  #   @collection = current_debtor.collections.build(collections_params)
  #   if @collection.save
  #     flash[:success] = "Factura creada."
  #     # redirect_to root_url
  #   else
  #     #render 'static_pages/home'
  #   end
  #   
  # end
  
end
