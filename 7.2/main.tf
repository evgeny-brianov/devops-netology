variable "yc_token" { type= string }
provider "yandex" {
  token     = var.yc_token
  cloud_id  = "b1gecqsa22e178i9vkau"
  folder_id = "b1g26nbtjlu2mabkioml"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "vm-1" {
  name       = "terraform72"
  
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

resource "yandex_vpc_network" "net-1" {
  name = "net-1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

