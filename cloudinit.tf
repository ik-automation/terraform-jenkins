# Cloud-init
data "template_cloudinit_config" "jenkins_cloudinit" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.jenkins_init_script.rendered}"
  }
}

data "template_file" "awslogs_cwlog" {
  template = "${file("${path.module}/user-data/cwlog.cfg")}"

  vars {
    group_name  = "${aws_cloudwatch_log_group.jenkins.name}"
    environment = "${var.environment}"
  }
}

data "template_file" "envars" {
  template = "${file("${path.module}/user-data/envars.sh")}"

  vars {
    region = "${var.region}"
    secret = "/${var.environment}/ci/password"
  }
}

data "template_file" "jenkins_init_script" {
  template = "${file("${path.module}/user-data/init.yml")}"

  vars {
    REGION                   = "${var.region}"
    environment              = "${var.environment}"
    config_as_code_jenkins   = "${base64gzip(file("${path.module}/user-data/jenkins.yml"))}"
    entrypoint               = "${base64gzip(file("${path.module}/user-data/entrypoint.sh"))}"
    bootstrap                = "${base64gzip(file("${path.module}/user-data/bootstrap.sh"))}"
    envars                   = "${base64gzip(data.template_file.envars.rendered)}"
    awslogs_service          = "${base64gzip(file("${path.module}/user-data/awslogs.service"))}"
    awslogs_cwlog            = "${base64gzip(data.template_file.awslogs_cwlog.rendered)}"
    awslogs_init             = "${base64gzip(file("${path.module}/user-data/cloudwatch.sh"))}"
    plugins_versions_jenkins = "${base64gzip(file("${path.module}/user-data/plugins.txt"))}"
  }
}
