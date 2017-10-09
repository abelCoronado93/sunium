require './sunstone/sunstone_test'
require './sunstone/vmgroup/VMGroup'

RSpec.describe "VMGroup test" do

    before(:all) do

        @auth = {
            :username => "oneadmin",
            :password => "opennebula"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @vmgrp = VMGroup.new(@sunstone_test)
        @wait = Selenium::WebDriver::Wait.new(:timeout => 15)
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create vmgroups" do
        hash_roles = {
            roles: [
                { name: "a", affinity: "NONE", hosts: ["30", "28"]},
                { name: "b", affinity: "NONE", hosts: ["27"]},
                { name: "c", affinity: "NONE", hosts: ["25"]},
                { name: "d", affinity: "AFFINED", hosts: ["26"]}
            ]
        }
        roles_affinity = [["b","d"]]
        roles_anti_affinity = [["a","c"]]
        @vmgrp.create("test", hash_roles, roles_affinity, roles_anti_affinity)
    end

    it "Check vmgroup" do
        hash={
            roles: [
                { name: "a", affinity: "NONE", hosts: []},
                { name: "b", affinity: "NONE", hosts: []},
                { name: "c", affinity: "NONE", hosts: []},
                { name: "d", affinity: "AFFINED", hosts: []}
            ]
        }
        roles_affinity = [["b","d"]]
        roles_anti_affinity = [["a","c"]]
        @vmgrp.check("test", hash, roles_affinity, roles_anti_affinity)
    end

    it "Delete vmgroup" do
        @vmgrp.delete("test")
    end

end