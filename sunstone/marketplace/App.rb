require './sunstone/Utils'
require 'pry'
class App

    def initialize(sunstone_test)
        @general_tag = "storage"
        @resource_tag = "marketplaceapps"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
    end

    def download(id)
        @utils.navigate(@general_tag, @resource_tag)

        @sunstone_test.get_element_by_id("marketplaceapp_#{id}").click

        element = @sunstone_test.get_element_by_id("#{@resource_tag}-tabmain_buttons")
        element.find_element(:class, "fa-cloud-download").click

        table = @sunstone_test.get_element_by_id("exportMarketPlaceAppFormdatastoresTable")
        tr_table = table.find_elements(tag_name: 'tr')
        tr_table[1].click if tr_table.length > 1

        @utils.submit_create(@resource_tag)
    end

end