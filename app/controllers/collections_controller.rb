#coding: utf-8
class CollectionsController < ApplicationController
  before_action :signed_in_user
  
  def new
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
  
  
  private
    def collections_params
      params.require(:collection).permit(:content)
    end
  
    # Moved to helper
    # def signed_in_user
  
end
