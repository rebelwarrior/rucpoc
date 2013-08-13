require 'spec_helper'

describe User do
  before do 
    @user = User.new(email:"example@jca.pr.gov")
  end
  subject { @user}
  
  it { should respond_to(:email)}
  
  # it 'should respond to "email"' do
  #   expect(@user).to respond_to(:email)
  # end
  
  it 'should be valid' do
    expect(@user).to be_valid
  end
  
  describe "when email not present" do
    before { @user.email = " "}
    it { should_not be_valid }
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example@foo. foo@baar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.com MIGUEL@b.f.org name@foo.gov 4+8eggs@number.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).to be_valid
      end
    end
  end
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it {should_not be_valid }
  end
      
  
  # pending "add some examples to (or delete) #{__FILE__}"
end
