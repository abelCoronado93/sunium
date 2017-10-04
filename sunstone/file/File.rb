require './sunstone/Utils'

class File

    def initialize(sunstone_test)
        @general_tag = "storage"
        @resource_tag = "files"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
    end

    def create(name, type, path)
        @utils.navigate_create(@general_tag, @resource_tag)

        @sunstone_test.get_element_by_id("img_name").send_keys "#{name}"

        dropdown = @sunstone_test.get_element_by_id("img_type")
        @sunstone_test.click_option(dropdown, type)

        @sunstone_test.get_element_by_id("img_path").send_keys "#{path}"

        @utils.submit_create(@resource_tag)
    end

end