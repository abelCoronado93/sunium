require './sunstone/sunstone_test'
require './sunstone/template/Template'

RSpec.describe "Template test" do

    before(:all) do
        @auth = {
            :username => "oneadmin",
            :password => "mypassword"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @template = Template.new(@sunstone_test)
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create one basic template" do
        @template.navigate
        hash = { name: "test_basic", mem: "2", cpu: "0.1" }
        @template.add_general(hash)
        @template.submit
    end

    it "Create one template with storage" do
        @template.navigate
        hash = { name: "test1", mem: "3", cpu: "0.2" }
        @template.add_general(hash)
        hash = { image: [ "0", "11" ], volatile: [{ size: "2", type: "fs", format: "qcow2" }] }
        @template.add_storage(hash)
        @template.submit
    end

    it "Create one template with vnets" do
        @template.navigate

        hash = { name: "test2", mem: "3", cpu: "0.2" }
        @template.add_general(hash)

        hash = { vnet: [ "1" ] }
        @template.add_network(hash)

        @template.submit
    end

end