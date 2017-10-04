require './sunstone/sunstone_test'

class Utils
    def initialize(sunstone_test)
        @sunstone_test = sunstone_test
    end

    def navigate_create(general, resource)
        if !$driver.find_element(:id, "#{resource}-tabcreate_buttons").displayed?
            navigate(general,resource)
        end
        element = @sunstone_test.get_element_by_id("#{resource}-tabcreate_buttons")
        element.find_element(:class, "create_dialog_button").click if element.displayed?
    end

    def navigate(general, resource)
        element = $driver.find_element(:id, "menu-toggle")
        element.click if element.displayed?
        @sunstone_test.get_element_by_id("li_#{general}-top-tab").click if !$driver.find_element(:id, "li_#{resource}-tab").displayed?
        @sunstone_test.get_element_by_id("li_#{resource}-tab").click if !$driver.find_element(:id, "#{resource}-tabcreate_buttons").displayed?
    end

    def submit_create(resource)
        element = @sunstone_test.get_element_by_id("#{resource}-tabsubmit_button")
        element.find_element(:class, "submit_button").click if element.displayed?
        sleep 1
    end
end