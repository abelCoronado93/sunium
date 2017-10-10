require './sunstone/sunstone_test'
require './sunstone/group/Group'

RSpec.describe "Group test" do

    before(:all) do
        @auth = {
            :username => "oneadmin",
            :password => "opennebula"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @group = Group.new(@sunstone_test)
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create one group" do
        @group.create("test")
    end

    it "Update group" do
        hash = {
            views:{
                dafault_user: "user",
                dafault_admin: "cloud",
                all: ["view_cloud","view_groupadmin"]
            }
        }
        @group.update("test", hash)
    end

    it "Delete Group" do
        @group.delete("test")
    end
end