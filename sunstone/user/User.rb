require './sunstone/Utils'
require 'pry'

class User

    def initialize(sunstone_test)
        @general_tag = "system"
        @resource_tag = "users"
        @datatable = "dataTableUsers"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
        @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    end

    def create_user(name_passwd, hash)
        @utils.navigate(@general_tag, @resource_tag)

        if !@utils.check_exists(2, name_passwd, @datatable)
            @utils.navigate_create(@general_tag, @resource_tag)

            @sunstone_test.get_element_by_id("createUserForm_username").send_keys "#{name_passwd}"
            @sunstone_test.get_element_by_id("createUserForm_pass").send_keys "#{name_passwd}"
            @sunstone_test.get_element_by_id("createUserForm_confirm_password").send_keys "#{name_passwd}"

            form = @sunstone_test.get_element_by_id("createUserFormWizard")
            dropdown = form.find_element(:class, "resource_list_select")

            options = dropdown.find_elements(tag_name: 'option')
            options.each { |option|
                option.click if option.text.include? "#{hash[:primary]}"
            }

            hash[:secondary].each { |secondary|
                table = $driver.find_element(:xpath, "//table[contains(@id, 'user-creation-one')]")
                tr_table = table.find_elements(tag_name: 'tr')
                tr_table.each { |tr|
                    td = tr.find_elements(tag_name: "td")
                    if td.length > 0 && td[0].text != "There is no data available"
                        if secondary == td[1].text
                            tr.click
                        end
                    end
                }
            }

            @utils.submit_create(@resource_tag)
        end
    end

    # Hash parameter can have this attributes:
    #  - :info, :attr, :groups, :quotas, :auth
    def check(name,hash={})
        @utils.navigate(@general_tag, @resource_tag)
        user = @utils.check_exists(2, name, @datatable)
        if user
            user.click
            tr_table = []
            if hash[:info]
                @wait.until{
                    tr_table = $driver.find_elements(:xpath, "//div[@id='user_info_tab']//table[@class='dataTable']//tr")
                    !tr_table.empty?
                }
                hash[:info] = @utils.check_elements(tr_table, hash[:info])

                if !hash[:info].empty?
                    hash[:info].each{ |obj| puts "#{obj[:key]} : #{obj[:key]}" }
                    fail "Check fail info: Not Found all keys"
                end
            end

            if hash[:attr]
                tr_table = $driver.find_elements(:xpath, "//div[@id='user_info_tab']//table[@id='user_template_table']//tr")
                hash[:attr] = @utils.check_elements(tr_table, hash[:attr])

                if !hash[:attr].empty?
                    hash[:attr].each{ |obj| puts "#{obj[:key]} : #{obj[:key]}" }
                    fail "Check fail attributes: Not Found all keys"
                end
            end

            if hash[:groups]
                @sunstone_test.get_element_by_id("user_groups_tab-label").click
                @sunstone_test.get_element_by_id("Form_change_second_grp")
                primary_grp = $driver.find_element(:xpath, "//form[@id='Form_change_second_grp']//h6[@class='show_labels']/a").text
                fail "Failed to check primary group" if primary_grp != hash[:groups][:primary]

                hash[:groups][:secondary].each { |secondary_grp|
                    if !@utils.check_exists(1, secondary_grp, "user_groups_tabGroupsTable")
                        fail "Failed to check secondary group #{secondary_grp}"
                    end
                }
            end

            if hash[:quotas]
                @sunstone_test.get_element_by_id("user_quotas_tab-label").click
                if !$driver.find_element(:xpath, "//div[@id='user_quotas_tab']//p").text.include? "There are no quotas defined"
                    hash[:quotas].each { |quota|
                        value_quota = $driver.find_element(:xpath, "//div[@quota_name='#{quota[:key]}']//progress").attribute("value")
                        fail "Failed to check quota #{quota[:key]} : #{quota[:value]}" if value_quota != quota[:value]
                    }
                else
                    fail "Not define quotas for #{name}"
                end
            end

            if hash[:auth]
                @sunstone_test.get_element_by_id("user_auth_tab-label").click
                tr_table = $driver.find_elements(:xpath, "//div[@id='user_auth_tab']//table[@id='dataTable']//tr")
                hash[:auth] = @utils.check_elements(tr_table, hash[:auth])

                if !hash[:auth].empty?
                    hash[:auth].each{ |obj| puts "#{obj[:key]} : #{obj[:key]}" }
                    fail "Check fail attributes: Not Found all keys"
                end
            end

        end
    end

    def delete(name)
        @utils.delete_resource(name, @general_tag, @resource_tag, @datatable)
    end

end