require './sunstone/sunstone_test'
require './sunstone/cluster/Cluster'
require './sunstone/vnet/VNet'
require './sunstone/datastore/Datastore'

RSpec.describe "Cluster test" do

    before(:all) do
        @auth = {
            :username => "oneadmin",
            :password => "opennebula"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @cluster = Cluster.new(@sunstone_test)
        @vnet = VNet.new(@sunstone_test)
        @ds = Datastore.new(@sunstone_test)
    end

    before(:each) do
        sleep 1
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create cluster" do
        hosts = []
        vnets = ["vnet1"]
        ds = ["default"]
        hash_vnet = {BRIDGE: "br0"}
        ars_vnet = [
            {type: "ip4", ip: "192.168.0.1", size: "100"}
        ]
        @vnet.create("vnet1", hash_vnet, ars_vnet)

        hash={
            tm: "dummy",
            type: "system"
        }
        @ds.create("default", hash)

        @cluster.create("test1", hosts, vnets, ds)
    end

    it "check cluster" do
        hash_info={ 
            hosts: [],
            vnets: ["vnet1"],
            ds: []
        }

        @cluster.check("test1", hash_info)
    end

    it "Update cluster" do
        hash = {
            hosts:[],
            vnets:[],
            ds:["test1"]
        }
        @cluster.update("test1", hash)
    end

    it "Delete cluster" do
       @cluster.delete("test1")
    end

end