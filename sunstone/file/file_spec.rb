require './sunstone/sunstone_test'
require './sunstone/file/File'

RSpec.describe "File test" do

    before(:all) do
        @auth = {
            :username => "oneadmin",
            :password => "opennebula"
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

    it "Check hosts" do
        hash_info=[
            {key:"Type", value:"KERNEL"}
        ]
        @file.check("test_kernel", hash_info)
    end

    it "Delete file" do
        @file.delete("test_context")
    end

end