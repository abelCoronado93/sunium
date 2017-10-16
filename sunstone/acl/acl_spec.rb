require './sunstone/sunstone_test'
require './sunstone/acl/Acl'

RSpec.describe "Acl test" do

    before(:all) do
        @auth = {
            :username => "oneadmin",
            :password => "mypassword"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @acl = Acl.new(@sunstone_test)
    end

    before(:each) do
        sleep 1
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create acl" do
        hash = {
            resources: ["host", "image"],
            subset: "all", 
            operations: ["manage"]
        }
        @acl.create("all", hash)
    end

    it "Delete acl" do
        @acl.delete_by_id("0")
    end

end