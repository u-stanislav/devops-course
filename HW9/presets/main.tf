# Generate SSH Key Pair
resource "tls_private_key" "ssh_key" {
  count     = 2
  algorithm = "RSA"
  rsa_bits  = 2048
}

# export keys
resource "local_file" "ssh_private_key_0" {
  content         = tls_private_key.ssh_key[0].private_key_pem
  filename        = "./id_rsa_0"
  file_permission = "0600"
}

resource "local_file" "ssh_public_key_0" {
  content  = tls_private_key.ssh_key[0].public_key_openssh
  filename = "./id_rsa_0.pub"
}


resource "local_file" "ssh_private_key_1" {
  content         = tls_private_key.ssh_key[1].private_key_pem
  filename        = "./id_rsa_1"
  file_permission = "0600"
}

resource "local_file" "ssh_public_key_1" {
  content  = tls_private_key.ssh_key[1].public_key_openssh
  filename = "./id_rsa_1.pub"
}