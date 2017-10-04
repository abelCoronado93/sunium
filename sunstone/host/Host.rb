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

end