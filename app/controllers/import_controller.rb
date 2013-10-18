class ImportController < ApplicationController
  before_action :signed_in_user
  def new
    testy = Struct.new(:errors, :each, :yield).new([0], [*1..9].each, "hi")
    testy.errors = [0]
    @product_import = ""#Import.new
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


__END__
def self.import(file)
  allowed_attributes = [ "id","name","released_on","price","created_at","updated_at"]
  spreadsheet = open_spreadsheet(file)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    product = find_by_id(row["id"]) || new
    product.attributes = row.to_hash.select { |k,v| allowed_attributes.include? k }
    product.save!
  end
end