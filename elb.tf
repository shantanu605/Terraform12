provider "aws" {
profile    = "my-profile"
region     = "us-east-2"
}

variable "elbname" {
   type = string
   }
variable "azname" {
  type = list
  default = ["us-east-2a","us-east-2b","us-east-2c"]
}
variable "timeout" {
  type = number
}


resource "aws_elb" "bar" {
  name               = var.elbname
  availability_zones = var.azname

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = var.timeout
  connection_draining         = true
  connection_draining_timeout = var.timeout

  tags = {
    Name = "testelb"
  }
}


variable "mapvar" {
 type = map
 default = {
  us-east-2a = "t2.large"
  us-east-2b = "t2.medium"
  us-east-2c = "t2.nano"
 }
}
variable "instancetype" {
type = list
default = ["t2.micro","t2.medium","t2.small","dev","test","prod"]
}
resource "aws_instance" "dev-team" {
ami = "ami-001089eb624938d9f"
instance_type = var.instancetype[0]
tags = {
 Name = var.instancetype[3]
 }
}
resource "aws_instance" "test-team" {
ami = "ami-001089eb624938d9f"
instance_type = var.instancetype[1]
tags = {
 Name = var.instancetype[4]
 }
}
resource "aws_instance" "prod-team" {
ami = "ami-001089eb624938d9f"
instance_type = var.instancetype[2]
tags = {
 Name = var.instancetype[5]
 }
}
