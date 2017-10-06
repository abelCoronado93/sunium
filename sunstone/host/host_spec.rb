require './sunstone/sunstone_test'
require './sunstone/host/Host'

RSpec.describe "Host test" do

    before(:all) do
        @auth = {
            :username => "oneadmin",
            :password => "opennebula"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @host = Host.new(@sunstone_test)
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create two dummy hosts" do
        @host.create_dummy("test1_dummy")
        @host.create_dummy("test2_dummy")
    end

    it "Create two kvm hosts" do
        @host.create_kvm("test1_kvm")
        @host.create_kvm("test2_kvm")
    end

    it "Check hosts" do
        hash=[
            {key:"IM MAD", value:"kvm"},
            {key:"VM MAD", value:"kvm"}
        ]
        @host.check("test2_kvm", hash)

        hash=[
            {key:"IM MAD", value:"dummy"},
            {key:"VM MAD", value:"dummy"}
        ]
        @host.check("test2_dummy", hash)
    end

    it "Delete hosts" do
        @host.delete("test1_dummy")
        @host.delete("test2_dummy")
        @host.delete("test1_kvm")
        @host.delete("test2_kvm")
    end

end