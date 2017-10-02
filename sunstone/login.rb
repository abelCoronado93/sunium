require 'rubygems'
require 'selenium-webdriver'

$driver = Selenium::WebDriver.for :firefox
$driver.get "http://localhost:9869"

element = $driver.find_element :id => "username"
element.send_keys "oneadmin"

element = $driver.find_element :id => "password"
element.send_keys "mypassword"

$driver.find_element(:id, "login_btn").click