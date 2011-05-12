require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => "Example User", 
              :email => "user@example.com",
              :password => "foobar",
              :password_confirmation => "foobar"
            }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name = User.new(@attr.merge(:name => ""))
    no_name.should_not be_valid
  end

  it "should require an email address" do
    no_email = User.new(@attr.merge(:email => ""))
    no_email.should_not be_valid
  end

  it "should reject names that are to long" do
    long_name_user = User.new(@attr.merge(:name => "A"*51))
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[commaproblem@foo,com noAt_at_foo.org no.domain@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    # Put a user with given email address into the db
    User.create!(@attr)
    dupe_user = User.new(@attr)
    dupe_user.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    dupe_user = User.new(@attr)
    dupe_user.should_not be_valid
  end

  describe "password validations" do
    it "should require a passwrd" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = 'a' * 5
      hash = @attr.merge(:password => short, 
                         :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = 'a' * 41
      hash = @attr.merge(:password => long,
                         :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end

  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attr" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrpted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if the passwords do not match" do
        @user.has_password?("invalid").should be_false
      end
    end

    describe "authenticate method" do
      it "should return nil on email/pass mismatch" do
        wrong_pass = User.authenticate(@attr[:email], "invalid")
        wrong_pass.should be_nil
      end

      it "should return nil for an email that is not a user" do
        nonexistent = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent.should be_nil
      end

      it "should return the user on email/pass match" do
        user = User.authenticate(@attr[:email], @attr[:password])
        user.should == @user
      end
    end
  end

  describe "admin attribute" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by deault" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

end
