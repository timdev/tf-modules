data aws_route53_zone "dest" {
  zone_id = "${var.zone_id}"
}

resource "aws_instance" "server" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  iam_instance_profile   = "${var.instance_profile_name}"
  key_name               = "${var.key_name}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = [
    "${var.vpc_security_group_ids}"]
  root_block_device      = {
    volume_size = "${lookup(var.root_block_device, "volume_size", 8)}"
    volume_type = "${lookup(var.root_block_device, "volume_type", "gp2")}"
  }
  tags                   = "${var.tags}"
  volume_tags            = "${var.volume_tags}"

  # Clean up local SSH stuff to keep things smooth
  provisioner "local-exec" {
    when    = "create"
    command = <<EOT
      ssh-keyscan -t rsa -v ${aws_instance.server.public_ip} >> ~/.ssh/known_hosts
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
    inline     = [
      "${var.provision_remote_commands}"]
  }

}


resource "aws_route53_record" "server" {
  zone_id    = "${data.aws_route53_zone.dest.id}"
  name       = "${var.instance_name}"
  type       = "CNAME"
  ttl        = 30
  records    = [
    "${aws_instance.server.public_dns}"
  ],
  provisioner "local-exec" {
    when    = "create"
    command = <<EOT
      ssh-keyscan -t rsa ${self.fqdn} >> ~/.ssh/known_hosts
      EOT
  }
  provisioner "local-exec" {
    when    = "destroy"
    command = <<EOT
      ssh-keygen -R ${self.fqdn}
      EOT
  }
}

