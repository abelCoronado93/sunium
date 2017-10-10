require './sunstone/Utils'

class App

    def initialize(sunstone_test)
        @general_tag = "storage"
        @resource_tag = "marketplaceapps"
        @datatable = "dataTableMarketplaceApps"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
    end

    def download(name)
        @utils.navigate(@general_tag, @resource_tag)
        app = @utils.check_exists(2, name, @datatable)
        if app
            app.find_element(:name, "selected_items").click

            element = @sunstone_test.get_element_by_id("#{@resource_tag}-tabmain_buttons")
            element.find_element(:class, "fa-cloud-download").click

            table = @sunstone_test.get_element_by_id("exportMarketPlaceAppFormdatastoresTable")
            tr_table = table.find_elements(tag_name: 'tr')
            tr_table[1].click if tr_table.length > 1

            @utils.submit_create(@resource_tag)
        else
            fail "Not found app: #{name}"
        end
    end

    def update(name, new_name, hash)
        @utils.navigate(@general_tag, @resource_tag)

        app = @utils.check_exists(2, name, @datatable)
        @utils.wait_jGrowl
        if app
            app.click
            if new_name != ""
                @utils.update_name(new_name)
            end
            if hash && !hash.empty?
                @utils.update_attr("marketplaceapp_template_table", hash)
            end
        end
    end

end