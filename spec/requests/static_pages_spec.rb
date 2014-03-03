require 'spec_helper'

describe "StaticPages" do
  
  # describe "Home Page" do
  #   itx 'should have a home page w/ content'
  # end
  
  describe "Help Page" do
    it 'should have information on how to use Rupoc' do
      visit '/help'
      expect(page).to have_content(/Como usar/i)
    end
    it 'should have the correct title' do
      visit '/help'
      expect(page).to have_title("Como Usar RucPoc")
    end
  end
  
  
  # describe "GET /static_pages" do
  #   it "works! (now write some real specs)" do
  #     # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
  #     get static_pages_index_path
  #     response.status.should be(200)
  #   end
  # end
end
