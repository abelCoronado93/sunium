require './sunstone/Utils'

class Acl

    def initialize(sunstone_test)
        @general_tag = "system"
        @resource_tag = "acls"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
    end

    def create(apply, hash, extra_apply = nil, extra_subset = nil)
        @utils.navigate_create(@general_tag, @resource_tag)

        checkbox = @sunstone_test.get_element_by_id("applies_#{apply}").click
        if !extra_apply.nil?
           element = @sunstone_test.get_element_by_id("applies_to_#{extra_apply[0]}")
           dropdown = element.find_element(:class, "resource_list_select");
           @sunstone_test.click_option(dropdown, "value", "#{extra_apply[1]}")
        end

        hash[:resources].each{ |resource| @sunstone_test.get_element_by_id("res_#{resource}").click }

        checkbox = @sunstone_test.get_element_by_id("res_subgroup_#{hash[:subset]}").click
        if !extra_subset.nil?
            if hash[:subset] == "id"
                @sunstone_test.get_element_by_id("res_#{extra_apply[0]}").send_keys "#{extra_apply[1]}"
            else
                element = @sunstone_test.get_element_by_id("#{extra_apply[0]}")
                dropdown = element.find_element(:class, "resource_list_select");
                @sunstone_test.click_option(dropdown, "value", "#{extra_apply[1]}")
            end
         end

         hash[:operations].each{ |op| @sunstone_test.get_element_by_id("right_#{op}").click }

        @utils.submit_create(@resource_tag)
    end
end