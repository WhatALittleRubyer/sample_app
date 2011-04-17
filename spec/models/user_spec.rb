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

end
