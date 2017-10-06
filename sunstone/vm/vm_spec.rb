require './sunstone/sunstone_test'
require './sunstone/vm/Vm'

RSpec.describe "Vm test" do

    before(:all) do
        @auth = {
            :username => "oneadmin",
            :password => "mypassword"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @vm = Vm.new(@sunstone_test)
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Instantiate one template" do
        @vm.instantiate("0")
    end

    it "Custom instantiate" do
        hash = { name: "test1", mem: "2", cpu: "0.2" }
        @vm.custom_instantiate("0", hash)
    end

end