# Instruct terraform to download the provider on `terraform init`
terraform {
  required_providers {
    xenorchestra = {
      source = "terra-farm/xenorchestra"
      version = "0.16.0"
    }
  }
}

# Configure the XenServer Provider
provider "xenorchestra" {
  # Must be ws or wss
  url      = "ws://xoa.localdomain" # Or set XOA_URL environment variable
  username = "admin"              # Or set XOA_USER environment variable
  password = "TiberGoogleIndy!@"              # Or set XOA_PASSWORD environment variable

  # This is false by default and
  # will disable ssl verification if true.
  # This is useful if your deployment uses
  # a self signed certificate but should be
  # used sparingly!
  insecure = true              # Or set XOA_INSECURE environment variable to any value
}

data "xenorchestra_pool" "pool" {
  name_label = "primary"
}

data "xenorchestra_template" "template" {
  name_label = "CentOS 8 Cloudinit"
}

data "xenorchestra_network" "net" {
  name_label = "sfp0"
}

data "xenorchestra_cloud_config" "ceph0_config" {
  name = "ceph0"
}

resource "xenorchestra_vm" "ceph0" {
    memory_max = 17179869184
    cpus  = 4
    cloud_config = data.xenorchestra_cloud_config.ceph0_config.template
    name_label = "ceph0"
    name_description = ""
    template = data.xenorchestra_template.template.id

    # Prefer to run the VM on the primary pool instance
    affinity_host = data.xenorchestra_pool.pool.master
    network {
      network_id = data.xenorchestra_network.net.id
    }

    disk {
      sr_id = "824ab36d-4e40-8dbf-913c-5d18cf31f4c2"
      name_label = "ceph-0-os"
      size = 107374182400 
    }

    tags = [
      "CentOS",
      "Ceph",
    ]
}

data "xenorchestra_cloud_config" "ceph1_config" {
  name = "ceph1"
}

resource "xenorchestra_vm" "ceph1" {
    memory_max = 17179869184
    cpus  = 4
    cloud_config = data.xenorchestra_cloud_config.ceph1_config.template
    name_label = "ceph1"
    name_description = ""
    template = data.xenorchestra_template.template.id

    # Prefer to run the VM on the primary pool instance
    affinity_host = data.xenorchestra_pool.pool.master
    network {
      network_id = data.xenorchestra_network.net.id
    }

    disk {
      sr_id = "824ab36d-4e40-8dbf-913c-5d18cf31f4c2"
      name_label = "ceph-0-os"
      size = 107374182400 
    }

    tags = [
      "CentOS",
      "Ceph",
    ]
}

data "xenorchestra_cloud_config" "ceph2_config" {
  name = "ceph2"
}

resource "xenorchestra_vm" "ceph2" {
    memory_max = 17179869184
    cpus  = 4
    cloud_config = data.xenorchestra_cloud_config.ceph2_config.template
    name_label = "ceph2"
    name_description = ""
    template = data.xenorchestra_template.template.id

    # Prefer to run the VM on the primary pool instance
    affinity_host = data.xenorchestra_pool.pool.master
    network {
      network_id = data.xenorchestra_network.net.id
    }

    disk {
      sr_id = "824ab36d-4e40-8dbf-913c-5d18cf31f4c2"
      name_label = "ceph-0-os"
      size = 107374182400 
    }

    tags = [
      "CentOS",
      "Ceph",
    ]
}