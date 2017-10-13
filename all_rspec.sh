#!/bin/bash

one stop
sunstone-server stop
sudo rm -r /var/lib/one/one.db
sudo rm /var/lib/one/.one/*_auth
one start
echo "oneadmin:opennebula" > /var/lib/one/.one/one_auth
sunstone-server start

echo "ACL"
rspec sunstone/acl/acl_spec.rb
echo "VNET"
rspec sunstone/vnet/vnet_spec.rb
echo "APPS"
rspec sunstone/marketplace/apps_spec.rb
echo "DATASTORE"
rspec sunstone/datastore/datastore_spec.rb
echo "HOST"
rspec sunstone/host/host_spec.rb
echo "CLUSTER"
rspec sunstone/cluster/cluster_spec.rb
echo "TEMPLATE"
rspec sunstone/template/template_spec.rb
echo "USER"
rspec sunstone/user/user_spec.rb
echo "GROUP"
rspec sunstone/group/group_spec.rb
echo "VMGROUP"
rspec sunstone/vmgroup/vmgroup_spec.rb
echo "IMAGE"
rspec sunstone/image/image_spec.rb
echo "FILE"
rspec sunstone/file/file_spec.rb
echo "VM"
rspec sunstone/vm/vm_spec.rb

exit 0