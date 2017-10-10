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
                @sunstone_test.get_element_by_id("div_edit_rename_link").click
                rename = @sunstone_test.get_element_by_id("input_edit_rename")
                rename.clear
                rename.send_keys new_name
            end
            if hash && !hash.empty?
                hash.each { |obj_attr|
                    attr_element = @utils.check_exists(0, obj_attr[:key], "marketplaceapp_template_table")
                    if attr_element
                        attr_element.find_element(:id, "div_edit").click
                        @sunstone_test.get_element_by_id("input_edit_#{obj_attr[:key]}").clear
                        attr_element.find_element(:id, "div_edit").click
                        @sunstone_test.get_element_by_id("input_edit_#{obj_attr[:key]}").send_keys obj_attr[:value]
                    else
                        @sunstone_test.get_element_by_id("new_key").send_keys obj_attr[:key]
                        @sunstone_test.get_element_by_id("new_value").send_keys obj_attr[:value]
                        @sunstone_test.get_element_by_id("button_add_value").click
                    end
                    @utils.wait_jGrowl
                }
            end
        end
    end

end