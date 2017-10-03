require './sunstone/sunstone_test'

RSpec.describe "Create Network test" do
    before(:all) do

        @auth = {
            :username => "oneadmin",
            :password => "mypassword"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login

        @wait = Selenium::WebDriver::Wait.new(:timeout => 15)
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create vnet" do
        element = $driver.find_element(:id, "menu-toggle")
        element.click if element.displayed?

        @sunstone_test.get_element_by_id("li_network-top-tab").click

        @sunstone_test.get_element_by_id("li_vnets-tab").click

        element = @sunstone_test.get_element_by_id("vnets-tabcreate_buttons")

        element.find_element(:class, "create_dialog_button").click if element.displayed?

        @sunstone_test.get_element_by_id("name").send_keys "test"

        @sunstone_test.get_element_by_id("vnetCreateBridgeTab-label").click
        @sunstone_test.get_element_by_id("bridge").send_keys "br0"

        @sunstone_test.get_element_by_id("vnetCreateARTab-label").click
        @sunstone_test.get_element_by_id("vnet_wizard_ar_tabs")

        @sunstone_test.get_element_by_id("ar0_ip_start").send_keys "192.168.0.1"
        @sunstone_test.get_element_by_id("ar0_size").send_keys "100"

        element = @sunstone_test.get_element_by_id("vnets-tabsubmit_button")
        element.find_element(:class, "submit_button").click if element.displayed?
    end

end