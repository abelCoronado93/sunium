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

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create datastore" do
        @ds.create("test1", "ssh", "system")
    end

    it "check datastore" do
        hash_info=[
            {key:"TM_MAD", value:"ssh"},
            {key:"Type", value:"SYSTEM"}
        ]

        @ds.check("test1", hash_info)
    end

end