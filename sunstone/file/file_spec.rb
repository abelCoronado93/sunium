require './sunstone/sunstone_test'
require './sunstone/file/File'
require 'pry'

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

    it "Create files" do
        hash = { type: "KERNEL", path: "."}
        @file.create("test_kernel", hash)
        hash = { type: "CONTEXT", path: "."}
        @file.create("test_context", hash)
    end

    it "Check files" do
        hash_info = [
            {key: "Type", value: "KERNEL"}
        ]
        @file.check("test_kernel", hash_info)
    end

    it "Update file" do
        hash = {
            info: [
                {key: "Type", value: "RAMDISK"}
            ],
            attr: [
                {key: "hola", value: "adios"}
            ]
        }
        @file.update("test_kernel", "file_updated", hash)
    end

    it "Delete file" do
        @file.delete("test_context")
    end
end