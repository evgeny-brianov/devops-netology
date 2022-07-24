terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket = "bucket-netology"
    region = "ru-central1-a"
    key = "devops-netology/terraform.tfstate"
    skip_region_validation = true
    skip_credentials_validation = true
  }
}
variable "yc_token" { type= string }
provider "yandex" {
  token     = var.yc_token
  cloud_id  = "b1gecqsa22e178i9vkau"
  folder_id = "b1gbcsll4bftts9kdd4b"
  zone      = "ru-central1-a"
}