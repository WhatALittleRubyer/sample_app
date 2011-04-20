require 'spec_helper'

describe "Users" do
  after(:each) do
    ActiveRecord::Base.connection.execute('delete from users')
  end

  describe "signup" do
    describe "failures" do
      it "should not create a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => ""
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end

    describe "successes" do
      it "should create a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => "Integration Tester"
          fill_in "Email",        :with => "integrator@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button  
          response.should render_template('users/show')
          response.should have_selector("div.flash.success", :content => "Welcome")
        end.should change(User, :count).by(1)
      end
    end
  end
end
