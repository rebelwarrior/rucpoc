require 'spec_helper'

feature 'Importing CSV' do
  subject(:csv_table) { FactoryGirl.build :csv_table }
  
  scenario " " do
    # It's using test db so no biggie
    
    # Import data must provide for a mock of test data
    # How do I do that??
    
    # Hit the "choose file button" on the <input id='file' > 
    # find_field(<<upload_file_id>>).click
    # system("<<full_path>>\\file_upload.exe \"#{<<file_path>>}\" \"File Upload\"")
    
    # 
    
    
    
  end
  
  #Unsuccesfully Importing CSV
  
end


describe "sanitize row" do
  it 'cleans up the row'
  
end