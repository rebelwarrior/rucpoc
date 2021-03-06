require 'smarter_csv' 
require 'progress_bar'

module ImportLogic 

  def self.process_CSV_file(file, total_lines = 0, charset="bom|utf-8", progress_bar=ProgressBar.new) #TODO named arguments
    # Fiber.new {
    begin
    start_time = Time.now
    counter = []
    ActiveRecord::Base.transaction do
      SmarterCSV.process(file, {:chunk_size => 10, verbose: true, file_encoding: "#{charset}" } ) do |file_chunk|
        file_chunk.each do |record_row|
          sanitized_row = sanitize_row(record_row)
          process_record_row(sanitized_row, {})
          progress_bar.inc
          #Fiber.yield # So the idea is to Pause execution to allow progress bar to load
          # thr = Thread.new  { progress_bar.inc }
          # thr.join
          counter << 1
          #stop thread here
          #resume fiber w/ size
          #restart thread?
          # Fiber.yield counter.size
        end
      end
      total_count = counter.size #progress_bar.read
      end_time = Time.now
      result = { total: total_count, time: ((end_time - start_time) / 60 ).round(2) }
      puts "\033[32m#{result}\033[0m\n"
    end
    #rescue #TODO what's the error for import failures??
    # rescue ActiveRecord::RecordInvalid => error_msg
    #   flash.now error_msg
    #   # redirect_to_import_path
    ensure
    end
    # }
  end
  
  def self.sanitize_row(record)
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
  
  def self.process_record_row(record, options={})
    debtor_already_defined_in_db_result = debtor_already_defined_in_db?(record)
    puts "Is this an id?? ====> #{debtor_already_defined_in_db_result} <====="
    collection_array = select_column_names(Collection)
    debtor_array = select_column_names(Debtor)
    if debtor_already_defined_in_db_result #no updating a collection (only creating new ones) updating w/ options later
      record[:debtor_id] = debtor_already_defined_in_db_result
      store_record(record, collection_array)
    elsif record[:debtor_name] and !record[:debtor_name].strip.downcase['null'] #create debtor
      puts "Is this a NAME?? ====> #{record[:debtor_name]} <====="
      debtor_record = add_missing_keys(record, debtor_array)
      debtor_record[:name] = record[:debtor_name]
      ## Change nil values for acceptable values:
        debtor_record[:employer_id_number] = '' if debtor_record[:employer_id_number].nil?
        debtor_record[:tel] = '0000000000' if debtor_record[:tel].nil?
        debtor_record[:email] = "#{rand(9999)}_#{Time.now.to_i}@example.com" if debtor_record[:email].nil?
      ##^^Change nil value for acceptable value^^
      debtor = store_record(debtor_record, debtor_array, Debtor)
      record[:debtor_id] = debtor.id 
      # puts " SO FAR ===+++ #{debtor}"
      # puts " SO FAR ===+++ #{record}"
      store_record(record, collection_array, Collection) unless record[:internal_invoice_number].blank?
    else
      # flash
      puts "WTF WTF WFT!!"
      false
    end 
  end
  
  def self.store_record(record, column_name_array=[], model=Collection) #refactor to use named arguments
     to_store_record = delete_all_keys_execpt(record, column_name_array)
     saved = model.new(to_store_record)
     puts saved.inspect
     begin
       saved.save!
     rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid 
       flash.now 
       #redirect
     end
     raise unless saved.persisted?
     #if succeeds..
     saved
   end

   def self.debtor_already_defined_in_db?(record)
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

   def self.delete_all_keys_execpt(hash_record, execpt_array= [])
     # returns hash with *only* keys defined in array 
     hash_record.select do |key|
       execpt_array.include?(key)
     end
   end
   
   def self.select_column_names(model)
     #removes autogenerated colums from array
     array_of_column_names = model.column_names.map {|x| x.to_sym}
     [:id, :created_at, :updated_at].each do |item|
       array_of_column_names.delete(item)
     end
     array_of_column_names
   end

   def self.add_missing_keys(hash_record, keys_array=[], default_value=nil)
     #remember merge is a one-way operation <=
     Hash[keys_array.map{|k| [ k, default_value ] }].merge(hash_record)
   end
  
end

