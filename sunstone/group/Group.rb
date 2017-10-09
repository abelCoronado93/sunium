require './sunstone/Utils'

class Group

    def initialize(sunstone_test)
        @general_tag = "system"
        @resource_tag = "groups"
        @datatable = "dataTableGroups"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
    end

    def create(name)
        @utils.navigate(@general_tag, @resource_tag)
        if !@utils.check_exists(2, name, @datatable)
            @utils.navigate_create(@general_tag, @resource_tag)
            @sunstone_test.get_element_by_id("name").send_keys "#{name}"
            @utils.submit_create(@resource_tag)
        end
    end

    def update(name, hash_update)
        @utils.navigate(@general_tag, @resource_tag)
        group = @utils.check_exists(2, name, @datatable)
        if group
            group.click
            @sunstone_test.get_element_by_id("group_info_tab")
            @sunstone_test.get_element_by_id("groups-tabmain_buttons")
            $driver.find_element(:xpath, "//span[@id='groups-tabmain_buttons']//button[@href='Group.update_dialog']").click
            @sunstone_test.get_element_by_id("groups-tab-wizardForms")

            if hash_update[:views]
                @sunstone_test.get_element_by_id("resource_views-label").click

                if hash_update[:views][:dafault_user]
                    options = $driver.find_elements(:xpath, "//select[@id='user_view_default']//option")
                    options.each{ |opt| opt.click if opt.attribute("value") == hash_update[:views][:dafault_user]}
                end
                if hash_update[:views][:dafault_admin]
                    options = $driver.find_elements(:xpath, "//select[@id='admin_view_default']//option")
                    options.each{ |opt| opt.click if opt.attribute("value") == hash_update[:views][:dafault_admin]}
                end

                if hash_update[:views][:all]
                    hash_update[:views][:all].each{ |view|
                        @sunstone_test.get_element_by_id("group_#{view}").click if @sunstone_test.get_element_by_id("group_#{view}").attribute('checked').nil?
                    }
                end
            end

            @utils.submit_create(@resource_tag)
        else
            fail "Group name: #{name} not exists"
        end
    end

    def delete(name)
        @utils.delete_resource(name, @general_tag, @resource_tag, @datatable)
    end

end