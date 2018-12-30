# Create Jenkins deployment template
resource "aws_launch_template" "jenkins_ci" {
  name        = "${format("%s-jenkins", var.environment)}"
  description = "${format("Jenkins CI Template", var.environment)}"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = "${var.volume_size}"
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  image_id      = "${data.aws_ami.ubuntu_ami.image_id}"
  instance_type = "${var.instance_type}"

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups             = ["${aws_security_group.jenkins.id}"]
    subnet_id                   = "${data.aws_subnet_ids.ci.ids[0]}"
    description                 = "${format("%s-jenkins-ci", var.environment)}"
  }

  placement {
    availability_zone = "${var.region}a"
  }

  iam_instance_profile {
    name = "${local.instance_profile}"
  }

  key_name  = "${var.key_name}"
  user_data = "${base64encode(data.template_cloudinit_config.jenkins_cloudinit.rendered)}"

  tag_specifications {
    resource_type = "instance"

    tags {
      Name         = "${format("%s-jenkins", var.environment)}"
      Description  = "Jenkins CI Server instance. Attach to target group when created."
      Attach       = "${format("%s-jenkins-ci-tg", var.environment)}"
      SubnetsIds   = "${join(",",data.aws_subnet_ids.ci.ids)}"
      SubnetsNames = "${format("%s-ci-*", var.environment)}"
      Environment  = "${var.environment}"
      Region       = "${var.region}"
    }
  }
  tag_specifications {
    resource_type = "volume"

    tags {
      Name        = "${format("%s-jenkins-ci", var.environment)}"
      Description = "Jenkins CI Server volume."
      Environment = "${var.environment}"
      Region      = "${var.region}"
    }
  }
  tags {
    Name         = "${format("%s-jenkins-ci", var.environment)}"
    Description  = "Jenkins CI Server instance. Attach to target group or LB."
    Attach       = "${format("%s-jenkins-ci-tg", var.environment)}"
    SubnetsIds   = "${join(",",data.aws_subnet_ids.ci.ids)}"
    SubnetsNames = "${format("%s-ci-*", var.environment)}"
    Environment  = "${var.environment}"
    Region       = "${var.region}"
  }
}
