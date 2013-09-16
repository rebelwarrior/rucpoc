#!/bin/env ruby
# encoding: utf-8

class LogsController < ApplicationController
  before_action :signed_in_user
  
  def new
    @user = current_user
    redirect_to debtors_path if cookies[:current_debtor_id].nil?
    @collection = Collection.find_by_id(params[:collection_id])
    @debtor = Debtor.find_by_id(@collection.debtor_id)
    @log = Log.new(:collection => @collection, :user_id => @user.id)
    # @log = @collection.logs.build
  end
  
  def create
    @user = current_user
    @debtor = Debtor.find_by_id(cookies[:current_debtor_id])
    @collection = Collection.find_by_id(params[:collection_id])
    # @log = Log.new(log_params) 
    params[:log].merge!(:user_id => current_user.id)
    @log = @collection.logs.build(log_params)
    # @collection.log.build(params[:log])
    if @log.save
      flash[:success] = "Nueva Bitácora Creada"
      redirect_to @collection
    else
      flash[:error] = "Bitácora no gravada"
      render 'new'
    end
    
  end
  
  def show
    @user = current_user
    @collection = Collection.find_by_id(params[:collection_id])
    # @logs = @collection.logs.all
    @log = Log.find_by_id(params[:id])
    
  end
  
  def index
    @user = current_user
    @collection = Collection.find_by_id(params[:collection_id])
    @logs = @collection.logs.all
  end
  
  def destroy
    @user = current_user
    if current_user.admin?
      #Should only be certain users --> Supervisor users.
      @collection = Collection.find_by_id(params[:collection_id])
      log = Log.find_by_id(params[:id])
      if log.destroy
        # Should set flag to delete rather than actually delete
        flash[:success] = "Bitacora borrada."
      end
      redirect_to collection_url
    else
      flash.now![:error] = "Solo Administradores pueden borrar la bitacora."
    end
  end


private

  def log_params
    params.require(:log).permit(:user_id, :collection_id, :content)
  end #:user_id, :collection_id, 

end
