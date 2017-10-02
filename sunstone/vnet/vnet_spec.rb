require './sunstone/sunstone_test'

RSpec.describe "Create Host test" do
    before(:all) do

        @auth = {
            :username => "oneadmin",
            :password => "opennebula"
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

        @wait.until {
           element = $driver.find_element(:id, "li_network-top-tab")
           element if element.displayed?
        }
        element.click

        @wait.until {
            element = $driver.find_element(:id, "li_vnets-tab")
            element if element.displayed?
        }
        element.click if element.displayed?

        @wait.until {
            element = $driver.find_element(:id, "vnets-tabcreate_buttons")
            element if element.displayed?
        }
        element.find_element(:class, "create_dialog_button").click if element.displayed?

        @wait.until {
            $driver.find_element(:id, "name")
        }
        element = $driver.find_element(:id, "name")
        element.send_keys("test")

        element = $driver.find_element(:id, "vnetCreateBridgeTab-label").click
        @wait.until {
            $driver.find_element(:id, "bridge")
        }
        element = $driver.find_element(:id, "bridge")
        element.send_keys("br0")

        element = $driver.find_element(:id, "vnetCreateARTab-label").click
        @wait.until {
            element = $driver.find_element(:id, "vnet_wizard_ar_tabs")
        }
        element = $driver.find_element(:id, "ar0_ip_start")
        element.send_keys("192.168.0.1")
        element = $driver.find_element(:id, "ar0_size")
        element.send_keys("100")

        
        element = $driver.find_element(:class, "submit_button")
        element.click if element.displayed?
    end

end