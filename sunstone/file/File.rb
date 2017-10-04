require './sunstone/Utils'

class File

    def initialize(sunstone_test)
        @general_tag = "storage"
        @resource_tag = "files"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
    end

    def create_kernel(name)
        @utils.navigate_create(@general_tag, @resource_tag)

        @utils.submit_create(@resource_tag)
    end

    def create_context(name)
        @utils.navigate_create(@general_tag, @resource_tag)

        @utils.submit_create(@resource_tag)
    end

end