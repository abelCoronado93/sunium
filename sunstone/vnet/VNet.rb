require './sunstone/Utils'
class VNet

    def initialize(sunstone_test)
        @general_tag = "network"
        @resource_tag = "vnets"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
    end

    def create(name, bridge, ip, size)
        @utils.navigate_create(@general_tag, @resource_tag)

        @sunstone_test.get_element_by_id("name").send_keys "#{name}"
        
        @sunstone_test.get_element_by_id("vnetCreateBridgeTab-label").click
        @sunstone_test.get_element_by_id("bridge").send_keys "#{bridge}"

        @sunstone_test.get_element_by_id("vnetCreateARTab-label").click
        @sunstone_test.get_element_by_id("vnet_wizard_ar_tabs")

        @sunstone_test.get_element_by_id("ar0_ip_start").send_keys "#{ip}"
        @sunstone_test.get_element_by_id("ar0_size").send_keys "#{size}"

        @utils.submit_create(@resource_tag)
    end

end