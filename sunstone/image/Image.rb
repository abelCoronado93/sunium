require './sunstone/Utils'

class Image

    def initialize(sunstone_test)
        @general_tag = "storage"
        @resource_tag = "images"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
    end

    def create_path(name, type, path)
        @utils.navigate_create(@general_tag, @resource_tag)

        @sunstone_test.get_element_by_id("img_name").send_keys "#{name}"

        dropdown = @sunstone_test.get_element_by_id("img_type")
        @sunstone_test.click_option(dropdown, type)

        @sunstone_test.get_element_by_id("path_image").click

        @sunstone_test.get_element_by_id("img_path").send_keys "#{path}"

        @utils.submit_create(@resource_tag)
    end

    def create_empty(name, type, gb_size)
        @utils.navigate_create(@general_tag, @resource_tag)

        @sunstone_test.get_element_by_id("img_name").send_keys "#{name}"

        dropdown = @sunstone_test.get_element_by_id("img_type")
        @sunstone_test.click_option(dropdown, type)

        @sunstone_test.get_element_by_id("datablock_img").click

        @sunstone_test.get_element_by_id("img_size").send_keys "#{gb_size}"
        
        @utils.submit_create(@resource_tag)
    end

end