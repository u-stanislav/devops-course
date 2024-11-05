# output the public key (for use in connecting to the VMs)
output "ssh_public_keys" {
  value = [for key in tls_private_key.ssh_key : key.public_key_openssh]
#  sensitive = true
}

# output the private key (optional; use with caution)
output "ssh_private_keys" {
  value     = [for key in tls_private_key.ssh_key : key.private_key_pem]
  sensitive = true
}