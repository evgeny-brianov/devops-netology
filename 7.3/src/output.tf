output "internal_ip_address_vm-1" {
  value = yandex_compute_instance.vm-1.*.network_interface.0.ip_address
}

output "external_ip_address_vm-1" {
  value = yandex_compute_instance.vm-1.*.network_interface.0.nat_ip_address
}

output "internal_ip_address_for-each" {
  value = values(yandex_compute_instance.for-each).*.network_interface.0.ip_address
}

output "external_ip_address_for-each" {
  value = values(yandex_compute_instance.for-each).*.network_interface.0.nat_ip_address