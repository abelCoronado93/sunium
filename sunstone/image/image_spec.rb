require './sunstone/sunstone_test'
require './sunstone/image/Image'

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

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create one OS image" do
        @image.create_path("test_os", "OS", ".")
    end

    it "Create one context file" do
        @image.create_empty("test_datablock", "DATABLOCK", "1")
    end

    it "Check images" do
        hash_info=[
            {key:"Type", value:"OS"},
            {key:"DRIVER", value:"raw"}
        ]
        @image.check("test_os", hash_info)
    end

    #it "Delete image" do
    #    @image.delete("test_datablock")
    #end

    it "Update image" do
        @image.update("test_os", "image_updated", "CDROM", "yes")
    end

end