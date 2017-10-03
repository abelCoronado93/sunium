require './sunstone/sunstone_test'

RSpec.describe "Create Host test" do
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

    it "Create host" do
        element = $driver.find_element(:id, "menu-toggle")
        element.click if element.displayed?

        @sunstone_test.get_element_by_id("li_infrastructure-top-tab").click

        @sunstone_test.get_element_by_id("li_hosts-tab").click

        element = @sunstone_test.get_element_by_id("hosts-tabcreate_buttons")
        element.find_element(:class, "create_dialog_button").click if element.displayed?

        dropdown_list = @sunstone_test.get_element_by_id("host_type_mad")
        options = dropdown_list.find_elements(tag_name: 'option')
        options.each { |option| option.click if option.text == "Custom" }

        @sunstone_test.get_element_by_id("name").send_keys "test"

        @sunstone_test.get_element_by_name("custom_vmm_mad").send_keys "dummy"
        @sunstone_test.get_element_by_name("custom_im_mad").send_keys "dummy"

        element = @sunstone_test.get_element_by_id("hosts-tabsubmit_button")
        element.find_element(:class, "submit_button").click if element.displayed?

    end

end