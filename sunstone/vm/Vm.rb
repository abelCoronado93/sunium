require './sunstone/Utils'

class Vm

    def initialize(sunstone_test)
        @general_tag = "instances"
        @resource_tag = "vms"
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

    def instantiate(template_id)
        self.navigate_create

        tr = @utils.check_exists(0, template_id, "vm_create")
        if tr
            tr.click
            @utils.submit_create(@resource_tag)
        else
            fail "Template ID: #{template_id} not exists"
        end
    end

    def custom_instantiate(template_id, json)
        self.navigate_create

        tr = @utils.check_exists(0, template_id, "vm_create")
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
            fail "Template ID: #{template_id} not exists"
        end

    end

end
