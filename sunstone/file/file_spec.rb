require './sunstone/sunstone_test'
require './sunstone/file/File'
require 'pry'

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

    before(:each) do
        sleep 1
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create files" do
        hash_kernel = { type: "KERNEL", path: '.'}
        hash_context = { type: "CONTEXT", path: '.'}
        @file.create("test_context", hash_context)
        @file.create("test_kernel", hash_kernel)
    end

    it "Check files" do
        hash_info = [{key: "Type", value: "KERNEL"}]
        @file.check("test_kernel", hash_info)
    end

    it "Update file" do
        hash = {
            info: [{key: "Type", value: "RAMDISK"}],
            attr: [{key: "ERROR", value: "ninguno"}]
        }
        @file.update("test_kernel", "", hash)
    end

    it "Delete file" do
        @file.delete("test_context")
    end
  
end