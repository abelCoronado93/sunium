require './sunstone/Utils'

class VNet

    def initialize(sunstone_test)
        @general_tag = "network"
        @resource_tag = "vnets"
        @datatable = "dataTableVNets"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
        @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    end

    def create(name, bridge, ip, size)
        @utils.navigate(@general_tag, @resource_tag)

        if !@utils.check_exists(2, name, @datatable)

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

    def check(name, hash=[], ars=[])
        @utils.navigate(@general_tag, @resource_tag)

        vnet = @utils.check_exists(2, name, @datatable)
        if vnet
            vnet.click
            #information
            @sunstone_test.get_element_by_id("#{@resource_tag}-tab")
            tr_table = []
            @wait.until{
                tr_table = $driver.find_elements(:xpath, "//table[@id='info_vnet_table']//tr")
                !tr_table.empty?
            }
            hash = @utils.check_elements(tr_table, hash)

            #network_template_table
            tr_table = $driver.find_elements(:xpath, "//div[@id='vnet_info_tab']//table[@id='network_template_table']//tr")
            hash = @utils.check_elements(tr_table, hash)

            #Address Range
            @sunstone_test.get_element_by_id("vnet_ar_list_tab-label").click
            @wait.until{
                $driver.find_element(:xpath, "//div[@id='ar_list_datatable_wrapper']//table[@id='ar_list_datatable']").displayed?
            }
            tr_table = $driver.find_elements(:xpath, "//div[@id='ar_list_datatable_wrapper']//table[@id='ar_list_datatable']//tr")
            ars.each{ |ar|
                tr_table.each { |tr|
                    td = tr.find_elements(tag_name: "td")
                    if td.length > 0
                        if ar[:IP] == td[2].text
                            tr.click
                            tables = $driver.find_elements(:xpath, "//div[@id='ar_show_info']//table[@class='dataTable']")
                            tables.each{ |table|
                                tr_table = table.find_elements(tag_name: 'tr')
                                tr_table.each { |tr|
                                    td = tr.find_elements(tag_name: "td")
                                    if td.length > 0
                                        if ar[(td[0].text).to_sym] && ar[(td[0].text).to_sym] != td[1].text
                                            puts "Check fail: #{ar[(td[0].text).to_sym]} : #{ar[(td[0].text).to_sym]}"
                                            fail
                                            break
                                        elsif ar[(td[0].text).to_sym] && ar[(td[0].text).to_sym] == td[1].text
                                            ars.delete(ar)
                                        end
                                    end
                                }
                            }
                            break
                        end
                    end
                }
            }

            if !hash.empty?
                puts "Check fail: Not Found all keys"
                hash.each{ |obj| puts "#{obj[:key]} : #{obj[:value]}" }
                fail
            end
            if !ars.empty?
                puts "Check fail: Not Found all address ranges"
                ars.each{ |ar| puts "#{ar[:IP]}" }
                fail
            end
        end
    end

    def delete(name)
        @utils.delete_resource(name, @general_tag, @resource_tag, @datatable)
    end

end