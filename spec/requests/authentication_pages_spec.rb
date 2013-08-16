#spec/requests/authentication_pages_spec.rb
require 'spec_helper'

describe "AuthenticationPages" do
  subject { page }
  
  describe "log in page" do
    before { visit login_path}
    
    it { should have_content('Log in') }
    # it { should have_title('Log in')}
  end
   
  
  # describe "GET /authentication_pages" do
  #   it "works! (now write some real specs)" do
  #     # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
  #     get authentication_pages_index_path
  #     response.status.should be(200)
  #   end
  # end
end
