require 'rubygems'
require 'selenium-webdriver'
require 'rspec'

class Host

    def initialize()
        @general_tag = "infrastructure"
        @resource_tag = "hosts"
    end

    def create
        element = $driver.find_element(:id, "menu-toggle")
        element.click if element.displayed?

        @wait.until {
           element = $driver.find_element(:id, "li_#{@general_tag}-top-tab")
           element if element.displayed?
        }
        element.click

        @wait.until {
            element = $driver.find_element(:id, "li_#{@resource_tag}-tab")
            element if element.displayed?
        }
        element.click if element.displayed?

        @wait.until {
            element = $driver.find_element(:id, "#{@resource_tag}-tabcreate_buttons")
            element if element.displayed?
        }
        element.find_element(:class, "create_dialog_button").click if element.displayed?
    end
end