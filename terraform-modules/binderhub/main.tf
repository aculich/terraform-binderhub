resource "random_id" "token" {
  count       = 2
  byte_length = 32
}

resource "null_resource" "remote_install" {
  connection {
    user        = "${var.admin_user}"
    private_key = "${file("${var.private_key_path}")}"
    host        = "${var.jupyter_domain}"
  }

  provisioner "file" {
    source      = "${path.module}/assets/"
    destination = "/tmp/"
  }

  provisioner "remote-exec" {
    inline = [
      "api_token=${random_id.token.0.hex} secret_token=${random_id.token.1.hex} jupyter_domain=${var.jupyter_domain} binder_domain=${var.binder_domain} TLS_email=${var.TLS_email} cpu_alloc=${var.cpu_alloc} mem_alloc=${var.mem_alloc_gb}  admin_user=${var.admin_user} bash /tmp/install-binderhub.sh"
    ]
  }
}
