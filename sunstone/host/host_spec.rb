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

    it "Create host" do
        element = $driver.find_element(:id, "menu-toggle")
        element.click if element.displayed?

        @wait.until {
           element = $driver.find_element(:id, "li_infrastructure-top-tab")
           element if element.displayed?
        }
        element.click

        @wait.until {
            element = $driver.find_element(:id, "li_hosts-tab")
            element if element.displayed?
        }
        element.click if element.displayed?

        @wait.until {
            element = $driver.find_element(:id, "hosts-tabcreate_buttons")
            element if element.displayed?
        }
        element.find_element(:class, "create_dialog_button").click if element.displayed?

    end

end