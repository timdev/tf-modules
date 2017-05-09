output id {
  value = "${aws_instance.server.id}"
}
output public_ip {
  value = "${aws_instance.server.public_ip}"
}
output private_ip {
  value = "${aws_instance.server.private_dns}"
}
output public_dns {
  value = "${aws_instance.server.public_dns}"
}
output private_dns {
  value = "${aws_instance.server.private_dns}"
}
output availability_zone {
  value = "${aws_instance.server.availability_zone}"
}
output instance_type {
  value = "${aws_instance.server.instance_type}"
}
output fqdn {
  value = "${aws_route53_record.server.fqdn}"
}
