require './sunstone/Utils'

class Datastore

    def initialize(sunstone_test)
        @general_tag = "storage"
        @resource_tag = "datastores"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
    end

    def create(name, storage_bck, ds_type)
        @utils.navigate_create(@general_tag, @resource_tag)

        @sunstone_test.get_element_by_id("name").send_keys "#{name}"

        dropdown = @sunstone_test.get_element_by_id("presets")
        @sunstone_test.click_option(dropdown, "tm", storage_bck)

        @sunstone_test.get_element_by_id("#{ds_type}_ds_type").click

        @utils.submit_create(@resource_tag)
    end
end