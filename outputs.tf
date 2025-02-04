output "ssh_f5_username" {
  value = "volterra-admin"
}

output "ssh_f5_password" {
  value = random_string.password.result
}
