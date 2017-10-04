require './sunstone/sunstone_test'
require './sunstone/host/Host'

RSpec.describe "Create Host test" do
    before(:all) do

        @auth = {
            :username => "oneadmin",
            :password => "opennebula"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @host = Host.new(@sunstone_test)
        @wait = Selenium::WebDriver::Wait.new(:timeout => 15)
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create four hosts" do
        @host.create_dummy("test1_dummy")
        @host.create_dummy("test2_dummy")
        @host.create_kvm("test1_kvm")
        @host.create_kvm("test2_kvm")
    end

end