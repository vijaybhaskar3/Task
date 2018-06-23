variable "aws_access_key" {
 
}
variable "aws_secret_key" { 
}
variable "region" {
  default = "us-west-2"
}
variable "vpc_main_id" {
  default = "vpc-14236473"
}
variable "privatekeypath" {
  default = "nagios.pem"
}
variable "keyname" {
  default = "nagios"
}
variable "amiid" {
  default = "ami-db710fa3"
}
