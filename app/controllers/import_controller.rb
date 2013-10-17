class ImportController < ApplicationController
  def new
    @product_import = Import.new
  end

  def create
    @product_import = Import.new(params[:product_import])
    if @product_import.save
      #Change root_url to debtors index
      redirect_to root_url, notice: "Imported products successfully."
    else
      render :new
    end
  end 
end
