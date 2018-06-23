
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_main_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]

  }
}

resource "aws_instance" "web" {
  ami           = "${var.amiid}"
  instance_type = "t2.micro"
  key_name = "${var.keyname}"
  security_groups = ["${aws_security_group.allow_all.name}"]

  tags {
    Name = "HelloWorld"
  }
  connection {
  type     = "ssh"
  user     = "ubuntu"
  private_key = "${file(var.privatekeypath)}"
}
provisioner "remote-exec" {
   inline = [
     "sudo apt-get update",
     "sudo apt-get install apache2 -y",
     "sudo chmod  o+w /var/www/html/index.html",
     "sudo echo 'Hello from EC2 Instance 1' >> /var/www/html/index.html ",
     "sudo service apache2 restart"
   ]
 }
 provisioner "file" {
  content     = "<h1>Hello from EC2 Instance 1</h1>"
  destination = "/var/www/html/index.html"
}
}
resource "aws_instance" "test" {
  ami           = "${var.amiid}"
  instance_type = "t2.micro"
  key_name = "${var.keyname}"
  security_groups = ["${aws_security_group.allow_all.name}"]

  tags {
    Name = "HelloWorld1"
  }
  connection {
  type     = "ssh"
  user     = "ubuntu"
  private_key = "${file(var.privatekeypath)}"
}
provisioner "remote-exec" {
   inline = [
     "sudo apt-get update",
     "sudo apt-get install apache2 -y",
     "sudo chmod  o+w /var/www/html/index.html",
     "sudo service apache2 restart"
   ]
 }
 provisioner "file" {
  content     = "<h1>Hello from EC2 Instance 2</h1>"
  destination = "/var/www/html/index.html"
}
}
resource "aws_elb" "task" {
  name               = "my-terraform-elb"
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = ["${aws_instance.web.id}", "${aws_instance.test.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "my-terraform-elb"
  }

}
resource "null_resource" "cdn" {
  provisioner "local-exec" {
    command = "aws cloudfront create-distribution   --origin-domain-name ${aws_elb.task.dns_name} --default-root-object index.html"
    interpreter = ["PowerShell", "-Command"]
  }
}
