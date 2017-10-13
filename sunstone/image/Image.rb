require './sunstone/Utils'

class Image

    def initialize(sunstone_test)
        @general_tag = "storage"
        @resource_tag = "images"
        @datatable = "dataTableImages"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
        @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    end

    def create(json)
        @utils.navigate(@general_tag, @resource_tag)
        if !@utils.check_exists(2, json[:name], @datatable)
            @utils.navigate_create(@general_tag, @resource_tag)
            if json[:name]
                @sunstone_test.get_element_by_id("img_name").send_keys json[:name]
            end
            if json[:type]
                dropdown = @sunstone_test.get_element_by_id("img_type")
                @sunstone_test.click_option(dropdown, "value", json[:type])
            end
            if json[:path]
                @sunstone_test.get_element_by_id("path_image").click
                @sunstone_test.get_element_by_id("img_path").send_keys json[:path]
            elsif json[:size]
                @sunstone_test.get_element_by_id("datablock_img").click
                @sunstone_test.get_element_by_id("img_size").send_keys json[:size]
            end
            @utils.submit_create(@resource_tag)
        end
    end

    def check(name, hash={})
        @utils.navigate(@general_tag, @resource_tag)
        img = @utils.check_exists(2, name, @datatable)
        if img
            img.click
            tr_table = []
            @wait.until{
                tr_table = $driver.find_elements(:xpath, "//div[@id='image_info_tab']//table[@class='dataTable']//tr")
                !tr_table.empty?
            }
            hash = @utils.check_elements(tr_table, hash)

            tr_table = $driver.find_elements(:xpath, "//div[@id='image_info_tab']//table[@id='image_template_table']//tr")
            hash = @utils.check_elements(tr_table, hash)

            if !hash.empty?
                fail "Check fail: Not found all keys"
                hash.each{ |obj| puts "#{obj[:key]} : #{obj[:key]}" }
            end
        end
    end

    def delete(name)
        @utils.delete_resource(name, @general_tag, @resource_tag, @datatable)
    end

    def update(name, new_name, json)
        @utils.navigate(@general_tag, @resource_tag)
        image = @utils.check_exists(2, name, @datatable)
        if image
            image.click
            @sunstone_test.get_element_by_id("image_info_tab-label").click

            if json[:info] && !json[:info].empty?
                @utils.update_info("//div[@id='image_info_tab']//table[@class='dataTable']", json[:info])
            end

            if new_name != ""
                @utils.update_name(new_name)
            end
            @sunstone_test.get_element_by_id("#{@resource_tag}-tabback_button").click
        else
            fail "Image name: #{name} not exists"
        end
    end

end