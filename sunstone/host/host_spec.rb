require './sunstone/sunstone_test'

RSpec.describe "Create Host test" do
    before(:all) do

        @auth = {
            :username => "oneadmin",
            :password => "mypassword"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create host" do
        element = $driver.find_element(:id, "menu-toggle")
        element.click if element.displayed?
 
        element = $driver.find_element(:id, "li_infrastructure-top-tab")
        element.click if element.displayed?

        $driver.find_element(:id, "li_hosts-tab").click

        element = $driver.find_element(:id, "hosts-tabcreate_buttons button")
        element.click if element.displayed?
    end

end