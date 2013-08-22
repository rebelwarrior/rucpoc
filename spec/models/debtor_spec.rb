#coding: utf-8
require 'spec_helper'

describe Debtor do
  before do 
    @debtor = Debtor.new(name:"Enui Enterprises", email:"example@jca.pr.gov", tel:"787-999-0000", address:"P.O.Box 6667", 
    location:"A la vuelta de la esquina", contact_person:"Juan Bobo", employer_id_number:"")
  end
  subject { @debtor }
  
  it {should respond_to(:name)}
  it {should respond_to(:email)}
  it {should respond_to(:tel)}
  it {should respond_to(:address)}
  it {should respond_to(:location)}
  it {should respond_to(:contact_person)}
  it {should respond_to(:employer_id_number)}
  
  it 'should be valid' do
    expect(@debtor).to be_valid
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example@foo. foo@baar+baz.com]
      addresses.each do |invalid_address|
        @debtor.email = invalid_address
        expect(@debtor).not_to be_valid
      end
    end
  end
  describe "when EIN is blank" do
    it 'should be valid' do
      @debtor.employer_id_number = ''
      expect(@debtor).to be_valid
    end
  end
  describe "when EIN is invalid" do
    it "should be invalid" do
      @debtor.employer_id_number = '55-9'
      expect(@debtor).not_to be_valid
    end
  end
  
  # pending "add some examples to (or delete) #{__FILE__}"
end

__END__
heredoc = <<OEF
t.string :name
t.string :email
t.string :tel
t.string :address
t.string :location
t.string :contact_person
t.string :employer_ss
OEF