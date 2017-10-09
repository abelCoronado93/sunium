require './sunstone/Utils'
require 'pry'

class Template

    def initialize(sunstone_test)
        @general_tag = "templates"
        @resource_tag = "templates"
        @datatable = "dataTableTemplates"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
    end

    def navigate
        @utils.navigate_create(@general_tag, @resource_tag)
    end

    def submit
        @utils.submit_create(@resource_tag)
    end

    def add_general(json)
        if json[:name]
            @sunstone_test.get_element_by_id("NAME").send_keys json[:name]
        end

        if json[:mem]
            @sunstone_test.get_element_by_id("MEMORY_GB").send_keys json[:mem]
        end

        if json[:cpu]
            @sunstone_test.get_element_by_id("CPU").send_keys json[:cpu]
        end
    end

    def add_storage(json)
        @sunstone_test.get_element_by_id("storageTabone2-label").click
        i = 1
        if json[:image]
            json[:image].each { |name|
                div = $driver.find_element(:xpath, "//div[@diskid='#{i}']")
                div.find_element(:xpath, "//div[@diskid='#{i}']//Input[@value='image']").click
                table = div.find_element(tag_name: "table")
                tr_table = table.find_elements(tag_name: "tr")
                tr_table.each { |tr|
                    td = tr.find_elements(tag_name: "td")
                    if td.length > 0
                        tr.click if name.include? td[0].text
                    end
                }
                @sunstone_test.get_element_by_id("tf_btn_disks").click
                i+=1
            }
        end

        if json[:volatile]
            json[:volatile].each { |disk|
                div = $driver.find_element(:xpath, "//div[@diskid='#{i}']")
                div.find_element(:xpath, "//div[@diskid='#{i}']//Input[@value='volatile']").click
                div.find_element(:xpath, "//div[@diskid='#{i}']//div[@class='volatile']//Input[@id='SIZE']").send_keys disk[:size]
                if disk[:type]
                    dropdown = div.find_element(:xpath, "//div[@diskid='#{i}']//div[@class='volatile']//select[@id='TYPE_KVM']")
                    @sunstone_test.click_option(dropdown, "value", disk[:type])
                end
                if disk[:format]
                    dropdown = div.find_element(:xpath, "//div[@diskid='#{i}']//div[@class='volatile']//select[@id='FORMAT_KVM']")
                    @sunstone_test.click_option(dropdown, "value", disk[:format])
                end
                @sunstone_test.get_element_by_id("tf_btn_disks").click
                i+=1
            }
        end
    end

    def add_network(json)
        @sunstone_test.get_element_by_id("networkTabone3-label").click
        i = 1
        if json[:vnet]
            json[:vnet].each { |name|
                div = $driver.find_element(:xpath, "//div[@nicid='#{i}']")
                table = div.find_element(tag_name: "table")
                tr_table = table.find_elements(tag_name: "tr")
                tr_table.each { |tr|
                    td = tr.find_elements(tag_name: "td")
                    if td.length > 0
                        tr.click if name.include? td[0].text
                    end
                }
                @sunstone_test.get_element_by_id("tf_btn_nics").click
                i+=1
            }
        end
    end

    def add_user_inputs(json)
        @sunstone_test.get_element_by_id("contextTabone11-label").click
        if json[:input]
            $driver.find_element(:class, "add_user_input_attr").click
            json[:input].each { |input|
                table = $driver.find_element(:class, "user_input_attrs")
                tr_table = table.find_elements(tag_name: "tr")
                tr_table[tr_table.length - 2].find_element(:class, "user_input_name").send_keys input[:name]
                dropdown = tr_table[tr_table.length - 2].find_element(:class, "user_input_type")
                @sunstone_test.click_option(dropdown, "value", input[:type])
                tr_table[tr_table.length - 2].find_element(:class, "user_input_description").send_keys input[:desc]
                if input[:mand] && input[:mand] == "false"
                    tr_table[tr_table.length - 2].find_element(:class, "switch-paddle").click
                end
                table.find_element(:class, "add_user_input_attr").click
            }
        end
    end

    def check(name,hash=[])
        @utils.navigate(@general_tag, @resource_tag)
        tmpl = @utils.check_exists(2, name, @datatable)
        if tmpl
            tmpl.click
            @sunstone_test.get_element_by_id("template_template_tab-label").click
            pre = $driver.find_element(:xpath, "//div[@id='template_template_tab']//pre")
            hash = @utils.check_elements_raw(pre, hash)

            if !hash.empty?
                puts "Check fail: Not Found all keys"
                hash.each{ |obj| puts "#{obj[:key]} : #{obj[:value]}" }
            end
        end
    end

    def delete(name)
        @utils.delete_resource(name, @general_tag, @resource_tag, @datatable)
    end

end