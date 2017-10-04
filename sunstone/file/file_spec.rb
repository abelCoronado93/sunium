require './sunstone/sunstone_test'
require './sunstone/file/File'

RSpec.describe "File test" do

    before(:all) do
        @auth = {
            :username => "oneadmin",
            :password => "mypassword"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @file = File.new(@sunstone_test)
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create one kernel file" do
        @file.create("test_kernel", "KERNEL", ".")
    end

    it "Create one context file" do
        @file.create("test_context", "CONTEXT", ".")
    end

end