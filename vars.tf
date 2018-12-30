variable environment {}
variable prefix {}
variable region {}
variable instance_type {}
variable jenkins_health_check {}
variable parent_dns_zone {}
variable key_name {}
variable deletion_protection {}
variable enable_access_logs {}
variable ssl_policy {}

variable log_retention {
  default = 3
}

variable admin_whitelist {
  type = "list"
}

variable team_whitelist {
  type = "list"
}

variable volume_size {
  default = "60"
}
