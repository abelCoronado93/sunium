require './sunstone/sunstone_test'
require './sunstone/user/User'

RSpec.describe "User test" do

    before(:all) do
        @auth = {
            :username => "oneadmin",
            :password => "mypassword"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @user = User.new(@sunstone_test)
        @wait = Selenium::WebDriver::Wait.new(:timeout => 15)
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create two normal user" do
        @user.create_user("John", false)
        @user.create_user("Paul", false)
    end

    it "Create one admin user" do
        @user.create_user("Doe", true)
    end

end