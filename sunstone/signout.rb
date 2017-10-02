require './login'

wait = Selenium::WebDriver::Wait.new()

puts "Login passed" if wait.until {
    element = $driver.find_element(:class, "opennebula-img")
}

$driver.find_element(:class, "username").click
$driver.find_element(:class, "logout").click

$driver.quit