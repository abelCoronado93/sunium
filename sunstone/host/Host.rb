require './sunstone/Utils'

class Host

    def initialize(sunstone_test)
        @general_tag = "infrastructure"
        @resource_tag = "hosts"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
    end

    def create_dummy(name)
        @utils.navigate_create(@general_tag, @resource_tag)

        dropdown = @sunstone_test.get_element_by_id("host_type_mad")
        @sunstone_test.click_option(dropdown, "value", "custom")

        @sunstone_test.get_element_by_id("name").send_keys "#{name}"

        @sunstone_test.get_element_by_name("custom_vmm_mad").send_keys "dummy"
        @sunstone_test.get_element_by_name("custom_im_mad").send_keys "dummy"

        @utils.submit_create(@resource_tag)
    end

    def create_kvm(name)
        @utils.navigate_create(@general_tag, @resource_tag)

        @sunstone_test.get_element_by_id("name").send_keys "#{name}"

        @utils.submit_create(@resource_tag)
    end

    def check(name,hash={})
        @utils.navigate(@general_tag, @resource_tag)
        table = @sunstone_test.get_element_by_id("dataTableHosts")
        tr_table = table.find_elements(tag_name: 'tr')
        tr_table.each { |tr|
            td = tr.find_elements(tag_name: "td")
            if td.length > 0
                if name == td[2].text
                    tr.click 
                    break
                end
            end
        }
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
