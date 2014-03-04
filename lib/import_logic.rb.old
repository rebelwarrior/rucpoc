module ImportLogic

public

  def process_CSV_file_3(file)
    ## For testing purposes file is redifined below
    file = '/Users/davidacevedo/Downloads/collections.csv'
    SmarterCSV.process(file, {:chunk_size => 10, verbose: true } ) do |file_chunk|
      file_chunk.each do |record_row|
        process_record_row(record_row, {})
      end
    end   
  end
  
private
  def process_record_row(record, options={})
    debtor_already_defined_in_db_result = debtor_already_defined_in_db?(record)
    if debtor_already_defined_in_db_result #no updating a collection (only creating new ones) updating w/ options later
      record[:debtor_id] = debtor_already_defined_in_db_result
      store_record(record)
    elsif record[:debtor_name] and !record[:debtor_name]['NULL'] #create debtor
      debtor_array = [:employer_id_number,:name,:tel,:email,:address,:location,:contact_person]
      debtor_record = add_missing_keys(record, debtor_array)
      debtor_record[:name] = record[:debtor_name]
      debtor = store_debtor_record(debtor_record, debtor_array)
      record[:debtor_id] = debtor.id
      store_record(record)
    else
      raise
      false
    end 
  end
  
  def store_record(record, collection_array=[])
    record = delete_all_keys_execpt(record)
    Collection.create(record)
    #if succeeds..
  end
  
  def store_debtor_record(record, debtor_array=[])
    debtor_record = delete_all_keys_execpt(record, debtor_array)
    Debtor.create(debtor_record)
    #if succeeds..
  end
  
  def debtor_already_defined_in_db?(record)
    #checks id, ein, then name and returns debtor_id or false
    if record[:debtor_id]
      debtor = Debtor.search(record.fetch(:debtor_id))
    elsif record[:employer_id_number]
      debtor = Debtor.search(record.fetch(:employer_id_number))
    elsif record[:debtor_name]
      debtor = Debtor.search(record.fetch(:debtor_name))
    else 
      debtor = nil
    end
    debtor.empty? ? false : debtor.id
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