locals {
  account_id          = "${data.aws_caller_identity.current.account_id}"
  elb_service_account = "${data.aws_elb_service_account.main.arn}"
  azs                 = ["2a", "2b", "2c"]
  log_retention       = "${var.log_retention}"
  admin_whitelist     = "${var.admin_whitelist}"
  parent_dns_zone     = "${var.parent_dns_zone}"
  jenkins_port        = 8080
  slave_port          = 50000
  instance_profile    = "arn:aws:iam::${local.account_id}:instance-profile/${var.environment}-ci-profile"
	domain              = "${replace(data.aws_route53_zone.parent.name, "/\\.$/", "")}"
}
