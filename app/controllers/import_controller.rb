class ImportController < ApplicationController
  before_action :signed_in_user
  require 'cmess/guess_encoding'
  # require 'reloader/sse'
  # include ActionController::Live
  require 'import_observer' #in lib directory
  require 'import_observable'
  @@counter ||= MyObservableClass.new
  @@observer ||= MyObserverClass.new
  @@counter.add_observer(@@observer)
  

  def new
    @user = current_user
    @import_title = "Importar"
    @file_lines = 0
  end

  def create
    # @counter = MyObservableClass.new
    # @counter.add_observer(MyObserverClass.new)
    begin
    # response.headers['Content-Type'] = 'text/event-stream'
    file = params[:file]
    if file.blank?
      # response.stream.close
      flash[:error] = "Ningún file selecionado."
      redirect_to action: 'new', status: 303 
    else
      file_lines = find_file_lines(file)
      # puts "Headers ==>> #{params[:file].headers} <<=="
      if file.headers['Content-Type: text/csv'] or file.headers['Content-Type: application/vnd.ms-excel']
        char_set = check_utf_encoding(file.tempfile)
        process_CSV_file(file.tempfile, file_lines, char_set) 
        redirect_to collections_path
      else 
        flash[:error] = "No es un CSV"
        flash[:notice] = file.headers
        # response.stream.close
        redirect_to action: 'new', status: 303 
      end
    end 
    ensure
      # response.stream.close
    end
    # render :text => proc {|response, output| output.write("50") }
    # render stream: true, layout: false
  end
  
  def process_CSV_file(*args)
    # @@counter ||= MyObservableClass.new
    @@counter.process_CSV_file(*args)
  end
  
  def progress
    # @@counter ||= MyObservableClass.new
    # @@counter.add_observer(MyObserverClass.new)
    # @@observer = MyObserverClass.new
    render text: @@observer.data, layout: false
    # render text: "hi", layout: false
    # response.headers['Content-Type'] = 'text/event-stream'
    # sse = Reloader::SSE.new(response.stream)
    # begin 
    #   loop do
    #     sse.write({ :time => Time.now})
    #     sleep 1
    #   end
    # rescue IOError
    #   # When the client disconnects, we'll get an IOError on write
    # ensure
    #   sse.close
    # end
    
    
  end

  public
    def check_utf_encoding(file)
      require 'cmess/guess_encoding'
      input = File.read(file)
      CMess::GuessEncoding::Automatic.guess(input)
    end

    def process_CSV_file_2(file, total_lines = 0, counter = 0)
      start_time = Time.now
      #Must make sure file is on UTF-8 Encoding or it will FAIL!!! How to check??
      charset = check_utf_encoding(file) || "bom|utf-8"
      #Insert Active Record transaction
      # sse = Reloader::SSE.new(response.stream)
      begin
      ActiveRecord::Base.transaction do
      # Must Check if any two lines are equal, use a hash funtion on each line and check the value of it.
      # begin
        SmarterCSV.process(file, {:chunk_size => 10, verbose: true, file_encoding: "#{charset}" } ) do |file_chunk|
          file_chunk.each do |record_row|
            sanitized_row = sanitize_row(record_row)
            process_record_row(sanitized_row, {})
            counter += 1
            changed
            notify_observers(counter)
            # send_message(tachy(counter, total_lines), sse)
          end
          # 10.times {counter << 1}
        end
        end_time = Time.now
        # send_message(100, sse, :close_it => true)
        flash[:success] = "#{counter} facturas procesadas en #{((end_time - start_time) / 60).round(2)} minutos."
      end
      rescue IOError
      ensure
        # sse.close
      end
      # rescue ActiveRecord:: => error
        # flash[:error] = error.inspect
      # end
    end
    
    def send_message(msg, obj, options ={})
      # response.headers['Content-Type'] = 'text/event-stream'
      # response.stream.write msg
      # response.stream.close
      obj.write msg
      obj.close if options[:close_it]
    end


  public 
    def find_file_lines(file)
      start_time = Time.now
      result = file.open.lines.inject(0){|total, amount| total += 1}
      file.open.rewind # To reset file.
      end_time = Time.now
      puts "Lines ==> #{@file_lines} in #{((end_time - start_time) / 60).round(2)}"
      result
    end
  
  
    def tachy(number, total)
      number / total * 100
    end
  
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

    def store_record(record, column_name_array=[], model=Collection) #refactor to use named arguments
      to_store_record = delete_all_keys_execpt(record, column_name_array)
      saved = model.new(to_store_record)
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

    def delete_all_keys_execpt(hash_record, execpt_array= [])
      # returns hash with *only* keys defined in array 
      hash_record.select do |key|
        execpt_array.include?(key)
      end
    end
    
    def select_column_names(model)
      #removes autogenerated colums from array
      array_of_column_names = model.column_names.map {|x| x.to_sym}
      [:id, :created_at, :updated_at].each do |item|
        array_of_column_names.delete(item)
      end
      array_of_column_names
    end

    def add_missing_keys(hash_record, keys_array=[], default_value=nil)
      #remember merge is a one-way operation <=
      Hash[keys_array.map{|k| [ k, default_value ] }].merge(hash_record)
    end
   
end


__END__
