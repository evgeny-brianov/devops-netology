**1.**
Создаем бакет для использования внешнего бэкенда. Значения описанны в bucket\main.tf

```
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

variable "yc_token" { type= string }
provider "yandex" {
  token     = var.yc_token
  cloud_id  = "b1gecqsa22e178i9vkau"
  folder_id = "b1gbcsll4bftts9kdd4b"
  zone      = "ru-central1-a"
}

variable "key_id" { type= string }
variable "sec" { type= string }
resource "yandex_storage_bucket" "bucket-netology" {
  access_key = var.key_id
  secret_key = var.sec
  bucket = "bucket-netology"
force_destroy = true
}
```
Создаем сервисный аккаунт с именем serv-acc:
```
[almanax@alma8 bucket]$ yc iam service-account create --name serv-acc
id: ajeo12ojf6o7cjof8iqc
folder_id: b1gbcsll4bftts9kdd4b
created_at: "2022-07-20T15:51:54.760295526Z"
name: serv-acc
```
Назначаем роль сервисному аккаунту serv-acc, используя его идентификатор:
```
yc resource-manager folder add-access-binding cloud-terraform \
  --role editor \
  --subject serviceAccount:ajeo12ojf6o7cjof8iqc
```
Создаем ключ доступа для сервисного аккаунта serv-acc:
```
yc iam access-key create --service-account-name serv-acc

access_key:
  id: ajeana01kc8s0t79b8nf
  service_account_id: ajeo12ojf6o7cjof8iqc
  created_at: "2022-07-20T16:06:13.533360853Z"
  key_id: *************************
secret: *****************************************
```
Инициализируем Terraform и видим результат:
```
yandex_storage_bucket.bucket-netology: Creating...
yandex_storage_bucket.bucket-netology: Still creating... [10s elapsed]
yandex_storage_bucket.bucket-netology: Still creating... [20s elapsed]
yandex_storage_bucket.bucket-netology: Still creating... [30s elapsed]
yandex_storage_bucket.bucket-netology: Still creating... [40s elapsed]
yandex_storage_bucket.bucket-netology: Still creating... [50s elapsed]
yandex_storage_bucket.bucket-netology: Still creating... [1m0s elapsed]
yandex_storage_bucket.bucket-netology: Creation complete after 1m2s [id=bucket-netology]
```
![11](https://user-images.githubusercontent.com/95703090/180633689-f8f60ea2-c57b-4eed-a25f-7833f7dd4982.jpg)

**2.** Первичную конфигурацию описываем в main.tf Описание бэкенда в provider.tf, переменные в backend.conf

Создаем ворспейсы:
```
[almanax@alma8 7.3]$ terraform workspace new stage
[almanax@alma8 7.3]$ terraform workspace new prod
[almanax@alma8 7.3]$ terraform workspace list
  default
* prod
  stage
```
Добавляем зависимость типа инстанса от воркспейса:
```
locals {
  platform_id_type = {
    stage = "standard-v1"
    prod = "standard-v2"
  }
}
```

Создаем count:
```
count = local.instance_count[terraform.workspace]

instance_count = {
    stage = "1"
    prod = "2"
  }
```

Добавляем группу инстансов через “for-each” модифицируя main.tf:
```
resource "yandex_compute_instance" "for-each" {
  name = "for-each"
  for_each = local.instances
  platform_id = each.key
```
Параметр жизненного цикла:
```
resource "yandex_compute_instance" "vm-1" {
  name       = "terraform73"
  platform_id = local.platform_id_type[terraform.workspace]
  count = local.instance_count[terraform.workspace]
  lifecycle {
    create_before_destroy = true
  }
```
<details><summary>Вывод terraform plan:</summary>

[almanax@alma8 7.3]$ terraform plan

var.yc_token
  Enter a value: ********************************************************

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.for-each["standard-v1"] will be created
  + resource "yandex_compute_instance" "for-each" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + name                      = "for-each"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd807ed79a4kkqfvd1mb"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = "yandex_vpc_subnet.subnet-1.id"
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.for-each["standard-v2"] will be created
  + resource "yandex_compute_instance" "for-each" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + name                      = "for-each"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd807ed79a4kkqfvd1mb"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = "yandex_vpc_subnet.subnet-1.id"
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-1[0] will be created
  + resource "yandex_compute_instance" "vm-1" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + name                      = "terraform73"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd807ed79a4kkqfvd1mb"
              + name        = (known after apply)
              + size        = 30
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-1[1] will be created
  + resource "yandex_compute_instance" "vm-1" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + name                      = "terraform73"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd807ed79a4kkqfvd1mb"
              + name        = (known after apply)
              + size        = 30
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.net-1 will be created
  + resource "yandex_vpc_network" "net-1" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "net-1"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet-1 will be created
  + resource "yandex_vpc_subnet" "subnet-1" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet1"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 6 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_for-each = [
      + (known after apply),
      + (known after apply),
    ]
  + external_ip_address_vm-1     = [
      + (known after apply),
      + (known after apply),
    ]
  + internal_ip_address_for-each = [
      + (known after apply),
      + (known after apply),
    ]
  + internal_ip_address_vm-1     = [
      + (known after apply),
      + (known after apply),
    ]
</details>

  
