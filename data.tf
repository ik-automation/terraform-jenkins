data "aws_caller_identity" "current" {}

data "aws_elb_service_account" "main" {}

data "aws_route53_zone" "parent" {
  name = "${var.environment}.${local.parent_dns_zone}."
}

data "aws_ami" "ubuntu_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_vpc" "selected" {
  tags {
    Environment = "${var.environment}"
    Name        = "${format("%s-vpc", var.environment)}"
  }
}

data "aws_subnet_ids" "ci" {
  vpc_id = "${data.aws_vpc.selected.id}"

  tags = {
    Name = "${format("%s-ci-*", var.environment)}"
  }
}

data "aws_subnet_ids" "alb" {
  vpc_id = "${data.aws_vpc.selected.id}"

  tags = {
    Environment = "${var.environment}"
    Name        = "${format("%s-public-*", var.environment)}"
    Visibility  = "public"
  }
}
