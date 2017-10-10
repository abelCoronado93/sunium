require './sunstone/Utils'

class Cluster

    def initialize(sunstone_test)
        @general_tag = "infrastructure"
        @resource_tag = "clusters"
        @datatable = "dataTableClusters"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
    end

    def create(name, hosts, vnets, ds)
        @utils.navigate(@general_tag, @resource_tag)

        if !@utils.check_exists(2, name, @datatable)
            @utils.navigate_create(@general_tag, @resource_tag)

            @sunstone_test.get_element_by_id("name").send_keys "#{name}"
            hosts.each{ |host_id|
                @utils.check_exists(0, host_id, "cluster_wizard_hosts").click
            }

            @sunstone_test.get_element_by_id("tab-vnetsTab-label").click
            vnets.each{ |vnet_id|
                @utils.check_exists(0, vnet_id, "cluster_wizard_vnets").click
            }

            @sunstone_test.get_element_by_id("tab-datastoresTab-label").click
            ds.each{ |ds_id|
                @utils.check_exists(0, ds_id, "cluster_wizard_datastores").click
            }

            @utils.submit_create(@resource_tag)
        end
    end

    def check(name, hash={})
        @utils.navigate(@general_tag, @resource_tag)

        cs = @utils.check_exists(2, name, @datatable)
        if cs
            cs.click
            @sunstone_test.get_element_by_id("#{@resource_tag}-tab")

            @sunstone_test.get_element_by_id("cluster_host_tab-label").click
            @sunstone_test.get_element_by_id("cluster_host_tabHostsTable_wrapper")

            hash[:hosts].each{ |host_id|
                if !@utils.check_exists(0, host_id, "cluster_host_tabHostsTable")
                    puts "Host not found: #{host_id}"
                    fail
                end
            }

            @sunstone_test.get_element_by_id("cluster_vnet_tab-label").click
            @sunstone_test.get_element_by_id("cluster_vnet_tabVNetsTable_wrapper")

            hash[:vnets].each{ |vnet_id|
                if !@utils.check_exists(0, vnet_id, "cluster_vnet_tabVNetsTable")
                    puts "Host not found: #{vnet_id}"
                    fail
                end
            }

            @sunstone_test.get_element_by_id("cluster_datastore_tab-label").click
            @sunstone_test.get_element_by_id("cluster_datastore_tabDatastoresTable_wrapper")

            hash[:ds].each{ |ds_id|
                if !@utils.check_exists(0, ds_id, "cluster_datastore_tabDatastoresTable")
                    puts "Host not found: #{ds_id}"
                    fail
                end
            }
        end
    end

    def update(name, hash)
        @utils.navigate(@general_tag, @resource_tag)
        cluster = @utils.check_exists(2, name, @datatable)
        if cluster
            cluster.click
            @sunstone_test.get_element_by_id("clusters-tabmain_buttons").click
            @sunstone_test.get_element_by_id("clusters-tab-wizardForms")
            if hash[:hosts]
                hash[:hosts].each { |host_name|
                    host = @utils.check_exists(1, host_name, "cluster_wizard_hosts")
                    if host
                        host.click if host.get_elements(tag_name: "td")[0].attribute("class").nil?
                    else
                        fail "Host name not found: #{host_name}"
                    end
                }
            end
            if hash[:vnets]
                @sunstone_test.get_element_by_id("tab-vnetsTab-label").click
                @sunstone_test.get_element_by_id("cluster_wizard_vnetsContainer")
                hash[:vnets].each { |vnet_name|
                    vnet = @utils.check_exists(1, vnet_name, "cluster_wizard_vnets")
                    if vnet
                        vnet.click if vnet.get_elements(tag_name: "td")[0].attribute("class").nil?
                    else
                        fail "Vnet name not found: #{vnet_name}"
                    end
                }
            end
            if hash[:ds]
                @sunstone_test.get_element_by_id("tab-tab-datastoresTab-label-label").click
                @sunstone_test.get_element_by_id("cluster_wizard_datastoresContainer")
                hash[:ds].each { |ds_name|
                    ds = @utils.check_exists(1, ds_name, "cluster_wizard_datastores")
                    if ds
                        ds.click if ds.get_elements(tag_name: "td")[0].attribute("class").nil?
                    else
                        fail "Datastore name not found: #{ds_name}"
                    end
                }
            end
            @utils.submit_create(@resource_tag)
        end
    end

    def delete(name)
        @utils.delete_resource(name, @general_tag, @resource_tag, @datatable)
    end
end