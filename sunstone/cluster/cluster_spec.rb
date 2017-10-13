require './sunstone/sunstone_test'
require './sunstone/cluster/Cluster'
require './sunstone/vnet/VNet'
require './sunstone/datastore/Datastore'

require 'pry'

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

        hash_vnet = {BRIDGE: "br0"}
        ars_vnet = [
            {type: "ip4", ip: "192.168.0.1", size: "100"}
        ]
        @vnet.create("vnet2", hash_vnet, ars_vnet)

        hash = {
            tm: "dummy",
            type: "system"
        }
        @ds.create("default", hash)
    end

    before(:each) do
        sleep 1
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create cluster" do
        hosts = []
        vnets = ["vnet2"]
        ddss = ["default"]
        @cluster.create("cluster", hosts, vnets, ddss)
    end

    it "check cluster" do
        hash_info = {
            hosts: [],
            vnets: ["vnet2"],
            ds: ["default"]
        }

        @cluster.check("cluster", hash_info)
    end

    it "Update cluster" do
        hash_ds = {
            tm: "dummy",
            type: "system"
        }
        @ds.create("ds", hash_ds)

        hash = {
            hosts: [],
            vnets: [],
            ds: ["ds"]
        }
        @cluster.update("cluster", hash)
    end

    it "Delete cluster" do
       @cluster.delete("cluster")
    end

end