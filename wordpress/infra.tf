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
  password    = var.admin_pass
  auth_url    = "http://172.16.0.210:5000"
  region      = "RegionOne"
}


### NETWORK
resource "openstack_networking_network_v2" "application-net" {
  name           = "application-net"
  description    = "Network for simple applications and network resources."
  shared         = "false"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  name        = "application-subnet"
  network_id  = "${openstack_networking_network_v2.application-net.id}"
  cidr        = "192.168.200.0/24"
  ip_version  = 4
  enable_dhcp = "true"
}

resource "openstack_networking_router_v2" "router_1" {
  name                = "application-router"
  admin_state_up      = true
  external_network_id = "dfebbc77-a6af-4f79-9ec4-b803feb486d5"
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = "${openstack_networking_router_v2.router_1.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet_1.id}"
}


### SECURITY GROUP(S)
resource "openstack_networking_secgroup_v2" "wordpress_secgrp" {
  name        = "wordpress_secgrp"
  description = "Security group used for WordPress instances. Exposes Http, Https, SSH and MySql."
}

resource "openstack_networking_secgroup_rule_v2" "http_secgrp_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.wordpress_secgrp.id}"
}

resource "openstack_networking_secgroup_rule_v2" "https_secgrp_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.wordpress_secgrp.id}"
}


resource "openstack_networking_secgroup_rule_v2" "ssh_secgrp_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.wordpress_secgrp.id}"
}

resource "openstack_networking_secgroup_rule_v2" "mysql_secgrp_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3306
  port_range_max    = 3306
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.wordpress_secgrp.id}"
}


### INSTANCE(S)
resource "openstack_compute_instance_v2" "wordpress" {
  name            = "wordpress"
  image_id        = "5d309ed3-e2f0-4ab9-bd68-180d31d0a13c"
  flavor_id       = "3"
  key_pair        = "Desktop-Linux"
  security_groups = ["default", "${openstack_networking_secgroup_v2.wordpress_secgrp.name}"]

  block_device {
    uuid                  = "5d309ed3-e2f0-4ab9-bd68-180d31d0a13c"
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = 40
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = "${openstack_networking_network_v2.application-net.id}"
  }
}


## FLOATING IP(S)
resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
  instance_id = "${openstack_compute_instance_v2.wordpress.id}"
}

