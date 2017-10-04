require './sunstone/sunstone_test'
require './sunstone/acl/Acl'

RSpec.describe "Acl test" do

    before(:all) do
        @auth = {
            :username => "oneadmin",
            :password => "opennebula"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @acl = Acl.new(@sunstone_test)
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create acl" do
        @acl.create("all", ["host","image"], "all", ["manage"])
    end

end