require 'spec_helper'

describe User do
  before do 
    @user = User.new(email:"example@jca.pr.gov", 
      password: "foobar", password_confirmation: "foobar")
  end
  subject { @user}
  
  specify { subject.should respond_to(:email)}
  it { should respond_to(:password_digest)}
  it { should respond_to(:password)}
  it { should respond_to(:password_confirmation)}
  it { should respond_to(:authenticate) }
  
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
  
  describe "when password is not present" do
    before do
      @user = User.new(email: "user@jca.pr.gov",
        password: " ", password_confirmation: " ")
    end
    it "should_not be_valid" do
      expect(@user).to_not be_valid
    end
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
  
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end 
  
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end
  
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end


end
