# output jenkins_dns {
#   value = "https://${aws_route53_record.jenkins.name}"
# }

output "logs" {
  value = "${aws_cloudwatch_log_group.jenkins.name}"
}

output local_domain {
  value = "${local.domain}"
}

output dns_zone_id {
  value = "${data.aws_route53_zone.parent.zone_id}"
}

output ci_subnet {
  value = "${data.aws_subnet_ids.ci.ids}"
}

output alb_security_group {
  value = "${aws_security_group.jenkins_elb.id}"
}

output jenkins_security_group {
  value = "${aws_security_group.jenkins.id}"
}

output "iam_instance_profile" {
  value = "${aws_iam_instance_profile.this.name}"
}

