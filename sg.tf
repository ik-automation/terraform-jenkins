resource "aws_security_group" "jenkins" {
  name        = "${format("%s-jenkins-ci-sg", var.environment)}"
  description = "Jenkins CI Security Group"
  vpc_id      = "${data.aws_vpc.selected.id}"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    description = "Provide access only within VPC"
    cidr_blocks = ["${data.aws_vpc.selected.cidr_block}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "TMP ssh access"
    cidr_blocks = ["${data.aws_vpc.selected.cidr_block}"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "TCP requests"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "TCP requests"
    cidr_blocks = ["0.0.0.0/0"]
  }

	egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "TCP requests"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    description = "MsSQL Server access"
    cidr_blocks = ["${data.aws_vpc.selected.cidr_block}"]
  }

  tags {
    Name        = "${var.environment}-jenkins-ci-sg"
    Environment = "${var.environment}"
    Description = "Attach to Jenkins CI Server"
    Attached    = "instance"
  }
}