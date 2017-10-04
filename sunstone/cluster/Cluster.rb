require './sunstone/Utils'

class Cluster

    def initialize(sunstone_test)
        @general_tag = "infrastructure"
        @resource_tag = "clusters"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
    end

    def create(name, table_num_host, table_num_vnet, table_num_ds)
        @utils.navigate_create(@general_tag, @resource_tag)

        @sunstone_test.get_element_by_id("name").send_keys "#{name}"

        table = @sunstone_test.get_element_by_id("cluster_wizard_hosts")
        tr_table = table.find_elements(tag_name: 'tr')
        tr_table[table_num_host].click if tr_table.length > table_num_host && table_num_host > 0

        @sunstone_test.get_element_by_id("tab-vnetsTab-label").click
        table = @sunstone_test.get_element_by_id("cluster_wizard_vnets")
        tr_table = table.find_elements(tag_name: 'tr')
        tr_table[table_num_vnet].click if tr_table.length > table_num_vnet && table_num_vnet > 0

        @sunstone_test.get_element_by_id("tab-datastoresTab-label").click
        table = @sunstone_test.get_element_by_id("cluster_wizard_datastores")
        tr_table = table.find_elements(tag_name: 'tr')
        tr_table[table_num_ds].click if tr_table.length > table_num_ds && table_num_ds > 0

        @utils.submit_create(@resource_tag)
    end
end