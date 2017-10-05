require './sunstone/sunstone_test'
require './sunstone/cluster/Cluster'

RSpec.describe "Cluster test" do

    before(:all) do
        @auth = {
            :username => "oneadmin",
            :password => "opennebula"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @cluster = Cluster.new(@sunstone_test)
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create cluster" do
        hosts = ["30"]
        vnets = ["17"]
        ds = ["102"]
        @cluster.create("test1", hosts, vnets, ds)
    end

    it "check cluster" do
        hash_info={ 
            hosts: ["30"],
            vnets: ["17"],
            ds: ["102"]
        }

        @cluster.check("test1", hash_info)
    end

end