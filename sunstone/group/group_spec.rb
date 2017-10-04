require './sunstone/sunstone_test'
require './sunstone/group/Group'

RSpec.describe "Group test" do

    before(:all) do
        @auth = {
            :username => "oneadmin",
            :password => "mypassword"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @group = Group.new(@sunstone_test)
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create four hosts" do
        @group.create("test")
    end

end