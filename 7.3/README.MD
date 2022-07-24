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

**2** Первичную конфигурацию описываем в main.tf Описание бэкенда в provider.tf
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

  
