require './sunstone/sunstone_test'
require './sunstone/vnet/VNet'

RSpec.describe "Network test" do

    before(:all) do

        @auth = {
            :username => "oneadmin",
            :password => "opennebula"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @vnet = VNet.new(@sunstone_test)
    end

    before(:each) do
        sleep 1
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create vnet" do
        hash = {BRIDGE: "br0"}
        ars = [
            {type: "ip4", ip: "192.168.0.1", size: "100"},
            {type: "ip4", ip: "192.168.0.2", size: "10"}
        ]
        @vnet.create("vnet1", hash, ars)
    end

    it "Check vnet" do
        hash_info = [ {key: "BRIDGE", value: "br0"} ]
        ars = [
            {IP: "192.168.0.1", SIZE: "100"}
        ]

        @vnet.check("vnet1", hash_info, ars)
    end

    it "Update vnet" do
        hash = { 
            attrs: []
        }
        @vnet.update("vnet1","", hash)
    end

    it "Delete vnet" do
        @vnet.delete("vnet1")
    end

end