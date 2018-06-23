output "address1" {
  value = "${aws_instance.test.public_dns}"
}

output "address" {
  value = "${aws_instance.web.public_dns}"
}

output "elb_address" {
  value = "${aws_elb.task.dns_name}"
}
