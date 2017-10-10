require './sunstone/sunstone_test'
require './sunstone/marketplace/App'

RSpec.describe "Apps test" do

    before(:all) do

        @auth = {
            :username => "oneadmin",
            :password => "opennebula"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @app = App.new(@sunstone_test)
        @wait = Selenium::WebDriver::Wait.new(:timeout => 15)
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Download app" do
        @app.download("CoreOS alpha")
    end

    it "update app" do
        hash = [
            {key: "DESCRIPTION", value: "selenium"}
        ]
        @app.update("CoreOS alpha", "", hash)
    end

end