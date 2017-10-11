require 'rubygems'
require 'selenium-webdriver'
require 'rspec'
require 'headless'
require 'pry'
class SunstoneTest

    def initialize(auth)
        options = Selenium::WebDriver::Chrome::Options.new
        #options.add_argument('headless')
        $driver = Selenium::WebDriver.for :chrome, :options => options
        $driver.get "http://localhost:9869"
        
        @auth = auth
    end

    def login
        element = $driver.find_element :id => "username"
        element.send_keys @auth[:username]
        
        element = $driver.find_element :id => "password"
        element.send_keys @auth[:password]
        
        $driver.find_element(:id, "login_btn").click

        wait = Selenium::WebDriver::Wait.new()
        
        puts "Login success" if wait.until {
            element = $driver.find_element(:class, "opennebula-img")
        }
    end

    def sign_out
        sleep 1
        self.get_element_by_id("userselector").click
        $driver.find_element(:class, "logout").click
        
        wait = Selenium::WebDriver::Wait.new(:timeout => 15)
        
        puts "\nSign out success" if wait.until {
            element = $driver.find_element(:id, "logo_sunstone")
        }

        $driver.quit
    end

    def js_errors?
        js_console_log = $driver.manage.logs.get("browser")
        messages = []
        js_console_log.each { |item|
            if item.level == "SEVERE" and !item.message.include? "Unauthorized"
                messages << item.message
            end
        }
        if messages.length > 0
            messages.each { |message|
                fail "js console error: '#{message}'" if message.length > 0
            }
            true
        else
            false
        end
    end

    def core_logs
        wait = Selenium::WebDriver::Wait.new(:timeout => 20)

        wait.until {
           $driver.find_element(:id, "jGrowl")
        }
        element = $driver.find_element(:id, "jGrowl")
        element.find_element(:class, "create_dialog_button").click if element.displayed?
    end

    def get_element_by_id(id)
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        wait.until {
            element = $driver.find_element(:id, id)
            return element if element.displayed?
        }
    end

    def get_element_by_name(name)
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        wait.until {
            element = $driver.find_element(:name, name)
            return element if element.displayed?
        }
    end

    def click_option(dropdown, attr, value)
        options = dropdown.find_elements(tag_name: "option")
        options.each { |option| option.click if option.attribute("#{attr}") == "#{value}" }
    end

end