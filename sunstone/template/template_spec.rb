require './sunstone/sunstone_test'
require './sunstone/template/Template'
require './sunstone/vnet/VNet'
require './sunstone/image/Image'

RSpec.describe "Template test" do

    before(:all) do
        @auth = {
            :username => "oneadmin",
            :password => "opennebula"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @template = Template.new(@sunstone_test)
        @vnet = VNet.new(@sunstone_test)
        @image = Image.new(@sunstone_test)

        hash = {BRIDGE: "br0"}
        ars = [
            {type: "ip4", ip: "192.168.0.1", size: "100"},
            {type: "ip4", ip: "192.168.0.2", size: "10"}
        ]
        @vnet.create("vnet1", hash, ars)

        hash = { name: "test_os", type: "OS", path: "."}
        @image.create(hash)
        hash = { name: "test_datablock", type: "DATABLOCK", size: "2"}
        @image.create(hash)
    end

    before(:each) do
        sleep 1
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create one basic template" do
        hash = { name: "temp_basic", mem: "2", cpu: "0.1" }
        if @template.navigate_create("temp_basic")
            @template.add_general(hash)
            @template.submit
        end
    end

    it "Create one template with storage" do
        hash = { name: "temp1", mem: "3", cpu: "0.2" }
        if @template.navigate_create("temp1")
            @template.add_general(hash)
            hash = { image: [ "test_datablock" ], volatile: [{ size: "2", type: "fs", format: "qcow2" }] }
            @template.add_storage(hash)
            @template.submit
        end
    end

    it "Create one template with vnets" do
        hash = { name: "temp2", mem: "3", cpu: "0.2" }
        if @template.navigate_create("temp2")
            @template.add_general(hash)
            hash = { vnet: [ "vnet1" ] }
            @template.add_network(hash)
            @template.submit
        end
    end

    it "Create one template with user inputs" do
        hash = { name: "temp3", mem: "2", cpu: "0.1" }
        if @template.navigate_create("temp3")
            @template.add_general(hash)
            hash = { input: [ {name: "input1", type: "text", desc: "input1", mand: "true"}, {name: "input2", type: "boolean", desc: "input2", mand: "false"} ] }
            @template.add_user_inputs(hash)
            @template.submit
        end
    end

    it "Create one complete template" do
        hash = { name: "temp_complete", mem: "5", cpu: "0.5" }
        if @template.navigate_create("temp_complete")
            @template.add_general(hash)
            hash = { image: [ "test_os" , "test_datablock" ], volatile: [{ size: "2", type: "fs", format: "qcow2" } ] }
            @template.add_storage(hash)
            hash = { vnet: [ "vnet1" ] }
            @template.add_network(hash)
            hash = { input: [ {name: "input1", type: "text", desc: "input1", mand: "true"}, {name: "input2", type: "boolean", desc: "input2", mand: "false"} ] }
            @template.add_user_inputs(hash)
            @template.submit
        end
    end

    it "Check templates" do
        hash_info = [
            { key: "LISTEN", value: "0.0.0.0" },
            { key: "TYPE", value: "VNC" }
        ]
        @template.check("temp_basic", hash_info)
    end

    it "Update template" do
        @template.navigate_update("temp_basic")
        hash = { mem: "2", cpu: "0.2" }
        @template.update_general(hash)
        hash = { volatile: [{ size: "2", type: "fs", format: "qcow2" } ] }
        @template.update_storage(hash)
        hash = { vnet: [ "vnet1" ] }
        @template.update_network(hash)
        hash = { input: [ {name: "input1", type: "text", desc: "input1", mand: "true"}, {name: "input2", type: "boolean", desc: "input2", mand: "false"} ] }
        @template.update_user_inputs(hash)
        @template.submit
    end

    it "Delete template" do
        @template.delete("temp_basic")
    end

end