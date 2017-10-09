require './sunstone/Utils'

class Vm

    def initialize(sunstone_test)
        @general_tag = "instances"
        @resource_tag = "vms"
        @datatable = "dataTableVms"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
    end

    def navigate_create
        if !$driver.find_element(:id, "#{@resource_tag}-tabcreate_buttons").displayed?
            @utils.navigate(@general_tag, @resource_tag)
        end
        element = @sunstone_test.get_element_by_id("#{@resource_tag}-tabcreate_buttons")
        element.find_element(:class, "action_button").click if element.displayed?
        @sunstone_test.get_element_by_id("vm_create_wrapper")
        sleep 0.5
    end

    def instantiate(template_name)
        self.navigate_create

        tr = @utils.check_exists(1, template_name, "vm_create")
        if tr
            tr.click
            @utils.submit_create(@resource_tag)
        else
            fail "Template name: #{template_id} not exists"
        end
    end

    def custom_instantiate(template_name, json)
        self.navigate_create

        tr = @utils.check_exists(1, template_name "vm_create")
        if tr
            tr.click
            if json[:name]
                @sunstone_test.get_element_by_id("vm_name").send_keys json[:name]
            end
            if json[:mem]
                div = $driver.find_element(:class, "gb_input")
                input = div.find_element(tag_name: "input")
                input.clear
                input.send_keys json[:mem]
            end
            if json[:cpu]
                div = $driver.find_element(:class, "cpu_input")
                input = div.find_element(tag_name: "input")
                input.clear
                input.send_keys json[:cpu]
            end

            @utils.submit_create(@resource_tag)
        else
            fail "Template name: #{template_name} not exists"
        end

    end

    def check(num_col, compare, hash=[])
        @utils.navigate(@general_tag, @resource_tag)
        tmpl = @utils.check_exists(num_col, compare, @datatable)
        if tmpl
            tmpl.click
            @sunstone_test.get_element_by_id("vm_template_tab-label").click
            pre = $driver.find_element(:xpath, "//div[@id='template_template_tab']//pre")
            hash = @utils.check_elements_raw(pre, hash)

            if !hash.empty?
                fail "Check fail: Not Found all keys"
                hash.each{ |obj| puts "#{obj[:key]} : #{obj[:value]}" }
            end
        end
    end

end
