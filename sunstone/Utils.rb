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
                        puts "Check fail: #{obj[:key]} : #{obj[:value]}"
                        fail
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
        navigate(general, resource)
        host = check_exists(2, name, datatable)
        if host
            td = host.find_elements(tag_name: "td")[0]
            td.find_element(:class, "check_item").click
            @sunstone_test.get_element_by_id("#{resource}-tabdelete_buttons").click
            @sunstone_test.get_element_by_id("confirm_proceed").click
        else
            puts "Error delete: Resource not found"
            fail
        end
        sleep 2
    end
end