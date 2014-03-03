class ImportController < ApplicationController
  before_action :signed_in_user #TODO allow progress action to be called
  require 'cmess/guess_encoding'
  require 'progress_bar'
  require 'import_logic_progress_bar'
  include ImportLogic
  

  def new
    @user = current_user
    @import_title = "Importar"
    @file_lines = 0
    @progress_bar = false
  end

  def create
    begin
    file = params[:file]
    if file.blank?
      flash[:error] = "Ningún file selecionado."
      redirect_to action: 'new', status: 303 
    else
      file_lines = find_file_lines(file)
      # puts "Headers ==>> #{params[:file].headers} <<=="
      if file.headers['Content-Type: text/csv'] or file.headers['Content-Type: application/vnd.ms-excel']
        char_set = check_utf_encoding(file.tempfile)
        @progress_bar = @progress_bar ? @progress_bar : ProgressBar.new
        process_CSV_file_wrapper(file.tempfile, file_lines, char_set, @progress_bar) #TODO named arguments 
        redirect_to collections_path
      else 
        flash[:error] = "No es un CSV"
        flash[:notice] = file.headers
        redirect_to action: 'new', status: 303 
      end
    end 
    ensure
    end
  end
  
  def process_CSV_file_wrapper(*args)
    # wrapper so as to be able to change methods easily.
    ImportLogic.process_CSV_file(*args)
  end
  
  def progress()
    #Possibly needs to be a stream
    @progress_bar = @progress_bar ? @progress_bar : ProgressBar.new
    Thread.new {
      render text: @progress_bar.read, layout: false
    }
  end
    

  private
    def check_utf_encoding(file)
      require 'cmess/guess_encoding'
      input = File.read(file)
      CMess::GuessEncoding::Automatic.guess(input)
    end
    
    def find_file_lines(file)
      start_time = Time.now
      result = file.open.lines.inject(0){|total, amount| total += 1}
      file.open.rewind # To reset file.
      end_time = Time.now
      puts "Lines ==> #{@file_lines} in #{((end_time - start_time) / 60).round(2)}"
      result
    end 
   
end


__END__
