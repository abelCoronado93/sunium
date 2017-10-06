require './sunstone/Utils'

class File

    def initialize(sunstone_test)
        @general_tag = "storage"
        @resource_tag = "files"
        @datatable = "dataTableFiles"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
        @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    end

    def create(name, type, path)
        @utils.navigate(@general_tag, @resource_tag)

        if !@utils.check_exists(2, name, @datatable)
            @utils.navigate_create(@general_tag, @resource_tag)

            @sunstone_test.get_element_by_id("img_name").send_keys "#{name}"

            dropdown = @sunstone_test.get_element_by_id("img_type")
            @sunstone_test.click_option(dropdown, "value", type)

            @sunstone_test.get_element_by_id("img_path").send_keys "#{path}"

            @utils.submit_create(@resource_tag)
        end
    end

    def check(name,hash={})
        @utils.navigate(@general_tag, @resource_tag)
        file = @utils.check_exists(2, name, @datatable)
        if file
            file.click
            tr_table = []
            @wait.until{
                tr_table = $driver.find_elements(:xpath, "//div[@id='file_info_tab']//table[@class='dataTable']//tr")
                !tr_table.empty?
            }
            hash = @utils.check_elements(tr_table, hash)

            tr_table = $driver.find_elements(:xpath, "//div[@id='file_info_tab']//table[@id='file_template_table']//tr")
            hash = @utils.check_elements(tr_table, hash)

            if !hash.empty?
                puts "Check fail: Not Found all keys"
                hash.each{ |obj| puts "#{obj[:key]} : #{obj[:key]}" }
            end
        end
    end

    def delete(name)
        @utils.delete_resource(name, @general_tag, @resource_tag, @datatable)
    end

end