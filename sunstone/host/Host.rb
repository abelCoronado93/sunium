require './sunstone/Utils'
require 'pry'

class Host

    def initialize(sunstone_test)
        @general_tag = "infrastructure"
        @resource_tag = "hosts"
        @datatable = "dataTableHosts"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
    end

    def create_dummy(name)
        @utils.navigate(@general_tag, @resource_tag)

        if !@utils.check_exists(2, name, @datatable)

            @utils.navigate_create(@general_tag, @resource_tag)

            dropdown = @sunstone_test.get_element_by_id("host_type_mad")
            @sunstone_test.click_option(dropdown, "value", "custom")

            @sunstone_test.get_element_by_id("name").send_keys "#{name}"

            @sunstone_test.get_element_by_name("custom_vmm_mad").send_keys "dummy"
            @sunstone_test.get_element_by_name("custom_im_mad").send_keys "dummy"

            @utils.submit_create(@resource_tag)

        end
    end

    def create_kvm(name)
        @utils.navigate(@general_tag, @resource_tag)

        if !@utils.check_exists(2, name, @datatable)

            @utils.navigate_create(@general_tag, @resource_tag)

            @sunstone_test.get_element_by_id("name").send_keys "#{name}"

            @utils.submit_create(@resource_tag)

        end
    end

    def check(name,hash={})
        @utils.navigate(@general_tag, @resource_tag)
        host = @utils.check_exists(2, name, @datatable)
        if host
            host.click
            div = @sunstone_test.get_element_by_id("host_info_tab")
            table = div.find_elements(:class, "dataTable")
            tr_table = table[0].find_elements(tag_name: 'tr')
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
