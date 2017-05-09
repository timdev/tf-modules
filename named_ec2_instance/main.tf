data aws_route53_zone "dest" {
  zone_id = "${var.zone_id}"
}

resource "aws_instance" "server" {
  # specific to us-west-1
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids =  ["${var.vpc_security_group_ids}"]
  root_block_device      = {
    volume_size = 24
    volume_type = "gp2"
  }
  tags                   = "${var.tags}"

  # Clean up local SSH stuff to keep things smooth
  provisioner "local-exec" {
    command = <<EOT
      ssh-keyscan ${aws_instance.server.public_ip} >> ~/.ssh/known_hosts
EOT
  }

  provisioner "remote-exec" {
    inline     = [
      "sudo apt -y update",
      "sudo apt -y upgrade",
      "sudo apt install -y python-minimal"
    ]
    connection = {
      type = "ssh"
      user = "ubuntu"
    }
  }

  provisioner "remote-exec" {
    connection = {
      type = "ssh"
      user = "ubuntu"
    }
    inline = ["${var.provision_remote_commands}"]
  }

}


resource "aws_route53_record" "server" {
  zone_id = "${data.aws_route53_zone.dest.id}"
  name    = "${var.instance_name}"
  type    = "CNAME"
  ttl     = 30
  records = [
    "${aws_instance.server.public_dns}"
  ],
  provisioner "local-exec" {
    when = "create"
    command = <<EOT
      ssh-keyscan ${self.fqdn} >> ~/.ssh/known_hosts
      EOT
  }
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
      ssh-keygen -R ${self.fqdn}
      EOT
  }
}

