terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

provider "openstack" {
  user_name   = "admin"
  tenant_name = "admin"
  password    = "pwd"
  auth_url    = "http://172.16.0.210:5000/v2.0"
  region      = "RegionOne"
}


### NETWORK
resource "openstack_networking_network_v2" "app-net" {
  name           = "app-net"
  admin_state_up = "true"
}

# resource "openstack_networking_subnet_v2" "subnet_1" {
#   name       = "subnet_1"
#   network_id = "${openstack_networking_network_v2.network_1.id}"
#   cidr       = "192.168.199.0/24"
#   ip_version = 4
# }

# resource "openstack_networking_floatingip_v2" "fip_1" {
#   pool = "my_pool"
# }


# ### SECURITY GROUP(S)
# resource "openstack_networking_secgroup_v2" "secgroup_1" {
#   name        = "secgroup_1"
#   description = "My neutron security group"
# }

# resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_1" {
#   direction         = "ingress"
#   ethertype         = "IPv4"
#   protocol          = "tcp"
#   port_range_min    = 22
#   port_range_max    = 22
#   remote_ip_prefix  = "0.0.0.0/0"
#   security_group_id = "${openstack_networking_secgroup_v2.secgroup_1.id}"
# }


# ### STORAGE
# resource "openstack_blockstorage_volume_v2" "volume_1" {
#   region      = "RegionOne"
#   name        = "volume_1"
#   description = "wordpress_volume"
#   size        = 40
# }



# ### INSTANCE(S)
# resource "openstack_compute_instance_v2" "wordpress" {
#   name            = "wordpress"
#   image_id        = "5d309ed3-e2f0-4ab9-bd68-180d31d0a13c"
#   flavor_id       = "3"
#   key_pair        = "Desktop-Linux"
#   security_groups = ["default", "wordpress"]

#   block_device {
#     uuid                  = "<image-id>"
#     source_type           = "image"
#     destination_type      = "local"
#     boot_index            = 0
#     delete_on_termination = true
#   }

#   block_device {
#     uuid                  = "${openstack_blockstorage_volume_v2.volume_1.id}"
#     source_type           = "volume"
#     destination_type      = "volume"
#     boot_index            = 1
#     delete_on_termination = true
#   }

#   network {
#     name = "my_network"
#   }
# }