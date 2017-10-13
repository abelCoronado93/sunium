require './sunstone/sunstone_test'
require './sunstone/user/User'

RSpec.describe "User test" do

    before(:all) do
        @auth = {
            :username => "oneadmin",
            :password => "opennebula"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @user = User.new(@sunstone_test)
        @wait = Selenium::WebDriver::Wait.new(:timeout => 15)
    end

    before(:each) do
        sleep 1
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create users, normal and admin" do
        hash = {
            primary: "users",
            secondary: ["users"]
        }
        @user.create_user("John", hash)
        @user.create_user("Paul", hash)

        hash = {
            primary: "oneadmin",
            secondary: []
        }
        @user.create_user("Doe", hash)
    end

    it "Check users" do
        hash={
            info:[
                {key:"Name", value:"oneadmin"}
                ],
            groups:{primary:"oneadmin", secondary:["oneadmin"]}
        }
        @user.check("oneadmin", hash)
    end

    it "update users" do
        hash={
            info: [
                {key: "Table Order", value: "desc"}
            ],
            attr: [
                {key: "hola", value: "adios"}
            ],
            groups:{primary:"oneadmin", secondary:["oneadmin"]}
        }
        @user.update("Doe", hash)
    end

    it "Delete user" do
        @user.delete("John")
    end

end