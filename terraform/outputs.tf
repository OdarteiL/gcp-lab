output "vm_external_ip" {
  description = "External IP of the web server"
  value       = google_compute_instance.web.network_interface[0].access_config[0].nat_ip
}

output "vm_name" {
  description = "VM instance name"
  value       = google_compute_instance.web.name
}
