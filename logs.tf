resource "aws_cloudwatch_log_group" "jenkins" {
  name              = "/${var.environment}/jenkins"
  retention_in_days = "${local.log_retention}"

  tags = {
    Environment = "${var.environment}"
    Application = "Jenkins"
  }
}
