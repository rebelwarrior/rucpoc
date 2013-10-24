class ImportController < ApplicationController
  before_action :signed_in_user
#   def new
#     testy = Struct.new(:errors, :each, :yield).new([0], [*1..9].each, "hi")
#     testy.errors = [0]
#     @product_import = ""#Import.new
#   end
# 
#   def create
#     @product_import = Import.new(params[:product_import])
#     if @product_import.save
#       #Change root_url to debtors index
#       redirect_to root_url, notice: "Imported products successfully."
#     else
#       render :new
#     end
#   end 
# end
  def new
    # ImportController.import(params[:file])
  end

  def create
    ImportController.import(params[:file])
  end

  def self.import(file)
    # Move this to lib?
    file = '/Users/davidacevedo/Downloads/collections.csv'
    imported_invoices = SmarterCSV.process(file, {:chunk_size => 10, :verbose => true }) do |chunk|
      #10 records (rows)
      chunk.each do |record|
        puts '$$$$$$$$$$$$$$$$$$$$$$$$'
        # {:id=>1, :internal_invoice_number=>22, :amount_owed=>5581.0, 
        # :paid=>"true", :notes=>"as;ldkfj", :bounced_check_bank=>"El banco Mio", 
        # :debtor_id=>2, :being_processed=>"false", :created_at=>"2013-08-26 11:57:01 -0400", 
        # :updated_at=>"2013-09-17 14:02:57 -0400", :debtor_name=>"NULL"}
        if record[:id].to_i.zero?
          record.delete(:id)
        elsif !Collection.find_by_id(record[:id]).empty?                 
        else 
          record.delete(:id)
        end
        
        if record[:debtor_id].to_i.zero?
          debtor = Debtor.find_by_name(record[:debtor_name]) unless (record[:debtor_name]['NULL'])
          if not debtor.empty?
            record[:debtor_id] = debtor.id
          elsif !record[:employer_id_number].empty? && !record[:debtor_name].empty?
            record[:email] = record[:email] || 'NULL'
            record[:tel] = record[:tel] || 'NULL'
            record[:address] = record[:address] || 'NULL'
            record[:location] = record[:location] || 'NULL'
            record[:contact_person] = record[:contact_person] || record[:transaction_contact_person]
            hash = {:employer_id_number => record[:employer_id_number], 
                    :name   =>  record[:debtor_name],
                    :tel    =>  record[:tel],
                    :email  =>  record[:email],
                    :address => record[:address],
                    :location =>record[:location],
                    :contact_person => record[:contact_person]
                  }
            debtor = Debtor.create!(hash)
            record[:debtor_id] = debtor.id
          else
            raise
          end
        else 
        puts record[:debtor_name]
        puts Debtor.find_by_name(record[:debtor_name]) unless (record[:debtor_name]['NULL']) #or record[:name]['debtor']
        puts '------------------------'
        puts record
        puts '%%%%%%%%%%%%%%%%%%%%%%%%'
        record.delete(:debtor_name)
        Collection.create(record)
      end
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