
// 亂數後綴, 以防重名
resource "random_id" "name_suffix" {
  byte_length = 2
}


resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "random_password" "coder-token" {
  length  = 8
  special = false
}

resource "local_file" "coder_info" {
  content = templatefile("template/coder.tmpl",
    {
      coders = google_compute_instance.code-server[*].network_interface.0.access_config.0.nat_ip
      # db_password     = nonsensitive(google_sql_user.users.password)
      coder_public_ip = google_compute_instance.code-server[0].network_interface.0.access_config.0.nat_ip
      token           = nonsensitive(random_password.coder-token.result)
    }
  )
  filename = "coder.md"
}

