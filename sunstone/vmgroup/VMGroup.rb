require './sunstone/Utils'

class VMGroup

    def initialize(sunstone_test)
        @general_tag = "templates"
        @resource_tag = "vmgroup"
        @datatable = "dataTableVMGroup"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
    end

    def create(name, roles, affinity = [], anti_affinity = [])
        @utils.navigate_create(@general_tag, @resource_tag)

        if !@utils.check_exists(2, name, @datatable)
            @sunstone_test.get_element_by_id("vm_group_name").send_keys "#{name}"
            i = 0
            roles[:roles].each{ |rol|

                tab = @sunstone_test.get_element_by_id("role#{i}Tab")
                tab.find_element(:id, "role_name").send_keys "#{rol[:name]}"

                tab.find_element(:xpath, "//Input[@value='#{rol[:affinity]}' and @name='protocol_role#{i}']").click

                table = @sunstone_test.get_element_by_id("table_hosts_role#{i}")
                tr_table = table.find_elements(tag_name: 'tr')
                tr_table.each { |tr|
                    td = tr.find_elements(tag_name: "td")
                    if td.length > 0
                        tr.click if rol[:hosts].include? td[0].text
                    end
                }
                i+=1
                if i < roles[:roles].length
                    @sunstone_test.get_element_by_id("tf_btn_roles").click
                end
            }
            dropdown = @sunstone_test.get_element_by_id("list_roles_select")
            affinity.each{ |affined|
                affined.each{ |rol|
                    @sunstone_test.click_option(dropdown, "value", rol)
                }
                @sunstone_test.get_element_by_id("tf_btn_host_affined").click
            }

            anti_affinity.each{ |anti_affined|
                anti_affined.each{ |rol|
                    @sunstone_test.click_option(dropdown, "value", rol)
                }
                @sunstone_test.get_element_by_id("tf_btn_host_anti_affined").click
            }

            @utils.submit_create(@resource_tag)
        end
    end

end