require './sunstone/Utils'
require 'pry'

class VNet

    def initialize(sunstone_test)
        @general_tag = "network"
        @resource_tag = "vnets"
        @datatable = "dataTableVNets"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
        @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    end

    def create(name, hash, ars)
        @utils.navigate(@general_tag, @resource_tag)

        if !@utils.check_exists(2, name, @datatable)

            @utils.navigate_create(@general_tag, @resource_tag)
            @sunstone_test.get_element_by_id("name").send_keys "#{name}"
            if hash[:BRIDGE]
                @sunstone_test.get_element_by_id("vnetCreateBridgeTab-label").click
                @sunstone_test.get_element_by_id("bridge").send_keys "#{hash[:BRIDGE]}"
            end
            
            if !ars.empty?
                @sunstone_test.get_element_by_id("vnetCreateARTab-label").click
                @sunstone_test.get_element_by_id("vnet_wizard_ar_tabs")
                i = 0
                ars.each{ |ar|
                    @sunstone_test.get_element_by_id("ar#{i}_ar_type_#{ar[:type]}").click
                    if ar[:type] == "ip6" || ar[:type] == "ether"
                        @sunstone_test.get_element_by_id("ar#{i}_mac_start").send_keys "#{ar[:mac]}"
                    else
                        @sunstone_test.get_element_by_id("ar#{i}_ip_start").send_keys "#{ar[:ip]}"
                    end
                    @sunstone_test.get_element_by_id("ar#{i}_size").send_keys "#{ar[:size]}"

                    @sunstone_test.get_element_by_id("vnet_wizard_ar_btn").click
                    i+=1
                }
            end

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

    def update(vnet_name, new_name, hash)
        @utils.navigate(@general_tag, @resource_tag)
        vnet = @utils.check_exists(2, vnet_name, @datatable)
        if vnet
            vnet.click
            @sunstone_test.get_element_by_id("vnet_info_tab")
            if new_name != ""
                @utils.update_name(new_name)
            end

            if hash[:attrs] && !hash[:attrs].empty?
                @utils.update_attr("network_template_table", hash[:attrs])
            end
        end
    end

end