require './sunstone/Utils'

class User

    def initialize(sunstone_test)
        @general_tag = "system"
        @resource_tag = "users"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
    end

    def create_user(name_passwd, admin)
        @utils.navigate_create(@general_tag, @resource_tag)

        @sunstone_test.get_element_by_id("createUserForm_username").send_keys "#{name_passwd}"
        @sunstone_test.get_element_by_id("createUserForm_pass").send_keys "#{name_passwd}"
        @sunstone_test.get_element_by_id("createUserForm_confirm_password").send_keys "#{name_passwd}"

        form = @sunstone_test.get_element_by_id("createUserFormWizard")
        dropdown = form.find_element(:class, "resource_list_select")

        options = dropdown.find_elements(tag_name: 'option')

        if admin 
            options.each { |option| option.click if option.text == "0: oneadmin" }
        else
            options.each { |option| option.click if option.text == "1: users" }
        end

        @utils.submit_create(@resource_tag)
    end

end