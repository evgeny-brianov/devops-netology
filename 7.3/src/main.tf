resource "yandex_compute_instance" "vm-1" {
  name       = "terraform73"
  platform_id = local.platform_id_type[terraform.workspace]
  count = local.instance_count[terraform.workspace]
  lifecycle {
    create_before_destroy = true
  }
  resources {
    cores  = 2
    memory = 4
    core_fraction = "100"
  }

  boot_disk {
    initialize_params {
      image_id = "fd807ed79a4kkqfvd1mb"	
      type        = "network-nvme"
      size        = "30"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
}

resource "yandex_compute_instance" "for-each" {
  name = "for-each"
  for_each = local.instances
  platform_id = each.key
  lifecycle {
    create_before_destroy = true
  }
  resources {
    cores  = 2
    memory = 4
    core_fraction = "100"
  }

   boot_disk {
     initialize_params {
     image_id = each.value
    }
  }
network_interface {
    subnet_id = "yandex_vpc_subnet.subnet-1.id"
    nat       = true
  }
}

resource "yandex_vpc_network" "net-1" {
  name = "net-1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

locals {
  platform_id_type = {
    stage = "standard-v1"
    prod = "standard-v2"
  }

instance_count = {
    stage = "1"
    prod = "2"
  }
instances = {
    "standard-v1" = "fd807ed79a4kkqfvd1mb"
    "standard-v2" = "fd807ed79a4kkqfvd1mb"
  }
}