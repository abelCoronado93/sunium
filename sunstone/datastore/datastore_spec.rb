require './sunstone/sunstone_test'
require './sunstone/datastore/Datastore'

RSpec.describe "Datastore test" do

    before(:all) do
        @auth = {
            :username => "oneadmin",
            :password => "opennebula"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @ds = Datastore.new(@sunstone_test)
    end

    before(:each) do
        sleep 1
    end
    
    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create datastore" do
        hash={
            tm: "ssh",
            type: "system"
        }
        @ds.create("test1", hash)
    end

    it "check datastore" do
        hash_info=[
            {key:"TM_MAD", value:"ssh"},
            {key:"Type", value:"SYSTEM"}
        ]

        @ds.check("test1", hash_info)
    end

    #it "Delete datastore" do
    #    @ds.delete("test1")
    #end
end