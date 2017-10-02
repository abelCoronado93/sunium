require './sunstone/sunstone_test'

RSpec.describe "Create Host test" do
    before(:all) do

        @auth = {
            :username => "oneadmin",
            :password => "mypassword"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "test" do
        puts "test"
    end

end