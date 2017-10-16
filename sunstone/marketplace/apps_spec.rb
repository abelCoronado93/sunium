require './sunstone/sunstone_test'
require './sunstone/marketplace/App'
require './sunstone/datastore/Datastore'

RSpec.describe "Apps test" do

    before(:all) do

        @auth = {
            :username => "oneadmin",
            :password => "mypassword"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @app = App.new(@sunstone_test)
        @wait = Selenium::WebDriver::Wait.new(:timeout => 15)
        @ds = Datastore.new(@sunstone_test)

        hash={
            tm: "dummy",
            type: "image"
        }
        @ds.create("ds_apps", hash)
    end

    before(:each) do
        sleep 1
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Download app" do
        @app.download("CoreOS alpha", "ds_apps")
    end

    it "Update app" do
        hash = [
            {key: "DESCRIPTION", value: "selenium"}
        ]
        @app.update("CoreOS alpha", "", hash)
    end

    it "Delete app" do
        @app.delete("FreeBSD 10.3")
    end
end