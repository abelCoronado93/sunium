require 'rubygems'
require 'selenium-webdriver'
require 'rspec'

class SunstoneTest

    def initialize(auth)
        $driver = Selenium::WebDriver.for :firefox
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
        $driver.find_element(:class, "username").click
        $driver.find_element(:class, "logout").click
        
        wait = Selenium::WebDriver::Wait.new(:timeout => 15)
        
        puts "\nSign out success" if wait.until {
            element = $driver.find_element(:id, "logo_sunstone")
        }

        $driver.quit
    end
end