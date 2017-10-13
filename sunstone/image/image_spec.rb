require './sunstone/sunstone_test'
require './sunstone/image/Image'
require 'pry'
RSpec.describe "Image test" do

    before(:all) do
        @auth = {
            :username => "oneadmin",
            :password => "opennebula"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @image = Image.new(@sunstone_test)
    end

    before(:each) do
        sleep 1
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create images" do
        hash = { name: "test_os", type: "OS", path: "."}
        @image.create(hash)
        hash = { name: "test_datablock", type: "DATABLOCK", size: "2"}
        @image.create(hash)
    end

    it "Check images" do
        hash_info = [
            { key:"Type", value:"OS" },
            { key:"DRIVER", value:"raw" }
        ]
        @image.check("test_os", hash_info)
    end

    it "Update image" do
        hash = {
            info: [
                {key: "Type", value: "DATABLOCK"},
                {key: "Persistent", value: "yes"}
            ]
        }
        @image.update("test_os", "image_updated", hash)
    end

    it "Delete image" do
        @image.delete("test_datablock")
    end

end