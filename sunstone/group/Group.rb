require './sunstone/Utils'

class Group

    def initialize(sunstone_test)
        @general_tag = "system"
        @resource_tag = "groups"
        @datatable = "dataTableGroups"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
    end

    def create(name)
        @utils.navigate_create(@general_tag, @resource_tag)
        if !@utils.check_exists(2, name, @datatable)
            @sunstone_test.get_element_by_id("name").send_keys "#{name}"
            @utils.submit_create(@resource_tag)
        end
    end

end