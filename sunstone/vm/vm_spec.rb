require './sunstone/sunstone_test'
require './sunstone/vm/Vm'
require './sunstone/template/Template'

RSpec.describe "Vm test" do

    before(:all) do
        @auth = {
            :username => "oneadmin",
            :password => "mypassword"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @vm = Vm.new(@sunstone_test)
        @template = Template.new(@sunstone_test)

        @template.navigate_create
        hash_template1 = { name: "test1", mem: "2", cpu: "0.1" }
        hash_template2 = { name: "test2", mem: "2", cpu: "0.1" }

        @template.add_general(hash_template1)
        @template.submit
        @template.navigate_create
        @template.add_general(hash_template2)
        @template.submit
    end

    before(:each) do
        sleep 1
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Instantiate one template" do
        @vm.instantiate("test1")
    end

    it "Custom instantiate" do
        hash = { name: "test1", mem: "2", cpu: "0.2" }
        @vm.custom_instantiate("test2", hash)
    end

    it "Check templates" do
        hash_info=[
            {key:"CPU", value:"0.2"}
        ]
        @vm.check(2, "test1", hash_info)
    end

end