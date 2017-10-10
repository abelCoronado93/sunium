require './sunstone/sunstone_test'

class Utils
    def initialize(sunstone_test)
        @sunstone_test = sunstone_test
    end

    def navigate_create(general, resource)
        if !$driver.find_element(:id, "#{resource}-tabcreate_buttons").displayed?
            navigate(general,resource)
        end
        element = @sunstone_test.get_element_by_id("#{resource}-tabcreate_buttons")
        element.find_element(:class, "create_dialog_button").click if element.displayed?
    end

    def navigate(general, resource)
        if !$driver.find_element(:id, "#{resource}-tabcreate_buttons").displayed?
            element = $driver.find_element(:id, "menu-toggle")
            element.click if element.displayed?
            @sunstone_test.get_element_by_id("li_#{general}-top-tab").click if !$driver.find_element(:id, "li_#{resource}-tab").displayed?
            @sunstone_test.get_element_by_id("li_#{resource}-tab").click
            sleep 1
        end
    end

    def submit_create(resource)
        element = @sunstone_test.get_element_by_id("#{resource}-tabsubmit_button")
        element.find_element(:class, "submit_button").click if element.displayed?
        sleep 2
    end

    # num_col: datatable column number (0: id, 1: name...)
    # compare: element to compare
    # datatable: datatable DOM id
    #
    # return: tr with match
    def check_exists(num_col = 2, compare, datatable)
        table = @sunstone_test.get_element_by_id("#{datatable}")
        tr_table = table.find_elements(tag_name: 'tr')
        tr_table.each { |tr|
            td = tr.find_elements(tag_name: "td")
            if td.length > 0 && td[0].text != "There is no data available"
                if compare == td[num_col].text
                    return tr
                end
            end
        }
        return false
    end

    # tr_table: tr Array
    # hash: Array [{key: "key", value: "value"}]
    #
    # return: hash without elements match
    def check_elements(tr_table, hash)
        tr_table.each { |tr|
            td = tr.find_elements(tag_name: "td")
            if td.length > 0
                hash.each{ |obj|
                    if obj[:key] == td[0].text && obj[:value] != td[1].text
                        fail "Check fail: #{obj[:key]} : #{obj[:value]}"
                        break
                    elsif obj[:key] == td[0].text && obj[:value] == td[1].text
                        hash.delete(obj)
                    end
                }
            end
        }
        return hash
    end

    def check_elements_raw(pre, hash)
        tmpl_text = pre.attribute("innerHTML")
        hash_copy = hash[0 .. hash.length]
        hash.each{ |obj|
            compare = obj[:key] + ' = "' + obj[:value] + '"'
            if tmpl_text.include? compare
                hash_copy.delete(obj)
            end
        }
        return hash_copy
    end

    def delete_resource(name, general, resource, datatable)
        self.navigate(general, resource)
        res = self.check_exists(2, name, datatable)
        if res
            td = res.find_elements(tag_name: "td")[0]
            td.find_element(:class, "check_item").click
            @sunstone_test.get_element_by_id("#{resource}-tabdelete_buttons").click
            @sunstone_test.get_element_by_id("confirm_proceed").click
        else
            fail "Error delete: Resource not found"
        end
        sleep 2
    end

    def wait_jGrowl
        begin
            while true do
                element = $driver.find_element(:class, "jGrowl-message")
                sleep 0.5
            end
        rescue Selenium::WebDriver::Error::NoSuchElementError

        end
    end

    def update_name(new_name)
        a = @sunstone_test.get_element_by_id("div_edit_rename_link")
        a.find_element(:tag_name, "i").click
        input_name = @sunstone_test.get_element_by_id("input_edit_rename")
        input_name.clear
        input_name.send_keys "#{new_name}"
    end

    def update_info(xpath, info)
        table = $driver.find_element(:xpath, xpath)
        tr_table = table.find_elements(tag_name: 'tr')
        info.each { |obj_attr|
            attr_element = false
            tr_table.each { |tr|
                td = tr.find_elements(tag_name: "td")
                if td.length > 0 && td[0].text != "There is no data available"
                    if obj_attr[:key] == td[0].text
                        attr_element = tr
                        break
                    end
                end
            }
            if attr_element
                if attr_element.find_elements(:id, "div_edit_#{obj_attr[:key]}").size() > 0

                    a = attr_element.find_element(:id, "div_edit")
                    a.find_element(:tag_name, "i").click
                    @sunstone_test.get_element_by_id("input_edit_#{obj_attr[:key]}").clear
                    attr_element.find_element(:id, "div_edit").click
                    @sunstone_test.get_element_by_id("input_edit_#{obj_attr[:key]}").send_keys obj_attr[:value]

                elsif  attr_element.find_elements(:id, "div_edit_table_order_link").size() > 0

                    a = attr_element.find_element(:id, "div_edit_table_order_link")
                    a.find_element(:tag_name, "i").click
                    options = $driver.find_elements(:xpath, "//select[@id='table_order_select']//option")
                    options.each{ |opt| opt.click if opt.text.include? obj_attr[:value]}

                end
            else
                fail "Information attribute not found: #{obj_attr[:key]}"
            end
            wait_jGrowl
        }
    end

    def update_attr(datatable_name, attrs)
        attrs.each { |obj_attr|
            attr_element = @utils.check_exists(0, obj_attr[:key], datatable_name)
            if attr_element
                attr_element.find_element(:id, "div_edit").click
                @sunstone_test.get_element_by_id("input_edit_#{obj_attr[:key]}").clear
                attr_element.find_element(:id, "div_edit").click
                @sunstone_test.get_element_by_id("input_edit_#{obj_attr[:key]}").send_keys obj_attr[:value]
            else
                @sunstone_test.get_element_by_id("new_key").send_keys obj_attr[:key]
                @sunstone_test.get_element_by_id("new_value").send_keys obj_attr[:value]
                @sunstone_test.get_element_by_id("button_add_value").click
            end
            @utils.wait_jGrowl
        }
    end

end