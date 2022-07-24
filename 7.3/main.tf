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
resource "yandex_storage_bucket" "cloud-terraform" {
  access_key = var.key_id
  secret_key = var.sec
  bucket = "bucket-netology"
force_destroy = true
}