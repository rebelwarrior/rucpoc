class ImportController < ApplicationController
  before_action :signed_in_user

  def new
    ImportController.import(params[:file])
  end

  def create
    process_CSV_file('/Users/davidacevedo/Downloads/June_with_headers_Invoices.csv') # (params[:file])
    redirect_to collections_path
  end

  public

    def process_CSV_file(file)
      ## For testing purposes file is redifined below
      # file = '/Users/davidacevedo/Downloads/collections.csv'
      file = '/Users/davidacevedo/Downloads/June_with_headers_Invoices.csv'
      puts "$$$$$$$$$$$$$$$$$"
      puts file
      #Must make sure file is on UTF-8 Encoding or it will FAIL!!! How to check??
      #Insert Active Record transaction
      ActiveRecord::Base.transaction do
      # Must Check if any two lines are equal, use a hash funtion on each line and check the value of it.
        SmarterCSV.process(file, {:chunk_size => 10, verbose: true, file_encoding: 'utf-8' } ) do |file_chunk|
          file_chunk.each do |record_row|
            #Sanitize row =>
            sanitized_row = sanitize_row(record_row)
            process_record_row(sanitized_row, {})
          end
        end
      end
    end

  private
    def sanitize_row(record)
      #iterate over each value and strip any Dangerous SQL 
      #key sanitation happens w/ a merge later on
      cleaned_record = {}
      record.each_pair do |k,v|
        #this might remove too much info...
        cleaned_record.store(k, 
          v.to_s.gsub(/\//i, '-').gsub(/[^[[:word:]]\-\.[[:blank:]]]/i, '') )  
        #put sql problem chars here only.gsub(/\W+/, ""))
      end
      cleaned_record
    end
  
    def process_record_row(record, options={})
      debtor_already_defined_in_db_result = debtor_already_defined_in_db?(record)
      puts "Is this an id?? ====> #{debtor_already_defined_in_db_result} <====="
      collection_array = [:collection_payment_emmiter_info, :collection_payment_id_number,
        :transaction_contact_person, :notes, :bounced_check_number, :bounced_check_bank, :debtor_id,
        :amount_owed, :internal_invoice_number ]
      if debtor_already_defined_in_db_result #no updating a collection (only creating new ones) updating w/ options later
        record[:debtor_id] = debtor_already_defined_in_db_result
        store_record(record, collection_array)
      elsif record[:debtor_name] and !record[:debtor_name].strip.downcase['null'] #create debtor
        puts "Is this a NAME?? ====> #{record[:debtor_name]} <====="
        puts " SO FAR ===+++ #{record}"
        debtor_array = [:employer_id_number,:name,:tel,:email,:address,:location,:contact_person]
        debtor_record = add_missing_keys(record, debtor_array)
        debtor_record[:name] = record[:debtor_name]
        # Change nil value for acceptable value
        debtor_record[:employer_id_number] = '' if debtor_record[:employer_id_number].nil?
        debtor_record[:tel] = '0000000000' if debtor_record[:tel].nil?
        debtor_record[:email] = "#{rand(9999)}_#{Time.now.to_i}@example.com" if debtor_record[:email].nil?
        # puts " SO FAR ===+++ #{debtor_record}"
          debtor = store_debtor_record(debtor_record, debtor_array)
          record[:debtor_id] = debtor.id 
          # puts " SO FAR ===+++ #{debtor}"
          puts " SO FAR ===+++ #{record}"
          store_record(record, collection_array) unless record[:internal_invoice_number].blank?
      else
        # flash
        puts "WTF WTF WFT!!"
        false
      end 
    end

    def store_record(record, collection_array=[])
      collection_record = delete_all_keys_execpt(record, collection_array) #there must be a bug here
      saved = Collection.new(collection_record)
      puts saved.inspect
      begin
        saved.save!
      rescue ActiveRecord::RecordNotUnique
        flash.now 
      end
      raise unless saved.persisted?
      #if succeeds..
      saved
    end

    def store_debtor_record(record, debtor_array=[])
      debtor_record = delete_all_keys_execpt(record, debtor_array)
      saved = Debtor.new(debtor_record)
      puts saved.inspect
      begin
        saved.save!
      rescue ActiveRecord::RecordNotUnique
        flash.now 
      end
      raise unless saved.persisted?
      #if succeeds.. do a save!
      saved
    end

    def debtor_already_defined_in_db?(record)
      #checks id, ein, then name and returns debtor_id or false
      debtor = nil
      #make below into a method and resend record stripping one at a time.
      if record[:debtor_id] and Debtor.find_by_id(record.fetch(:debtor_id))
        puts "ID SEARCH"
        debtor = Debtor.find(record.fetch(:debtor_id))
      elsif record[:employer_id_number] and Debtor.find_by_employee_id_number(record.fetch(:employer_id_number))
        puts "EIN SEARCH"
        debtor = Debtor.find_by_employee_id_number(record.fetch(:employer_id_number))
      elsif record[:debtor_name] and !record[:debtor_name].strip.downcase['null']
        puts "NAME SEARCH for #{record[:debtor_name]}" # This is FAILING!
        # debtor = Debtor.search(ActiveRecord::Base::sanitize(record.fetch(:debtor_name)))
        debtor = Debtor.find_by_name(record.fetch(:debtor_name))
      else 
        debtor = nil
      end
      debtor.blank? ? false : debtor.id
    end


    def delete_all_keys_execpt(hash_record, 
        execpt_array= [])
      hash_record.select do |key|
        execpt_array.include?(key)
      end
    end

    def add_missing_keys(hash_record, keys_array=[], default_value=nil)
      #remember merge is a one-way operation <=
      Hash[keys_array.map{|k| [ k, default_value ] }].merge(hash_record)
    end
   
end


__END__
# def self.import(file)
#   allowed_attributes = [ "id","name","released_on","price","created_at","updated_at"]
#   spreadsheet = open_spreadsheet(file)
#   header = spreadsheet.row(1)
#   (2..spreadsheet.last_row).each do |i|
#     row = Hash[[header, spreadsheet.row(i)].transpose]
#     product = find_by_id(row["id"]) || new
#     product.attributes = row.to_hash.select { |k,v| allowed_attributes.include? k }
#     product.save!
#   end
# end