resource "aws_iam_instance_profile" "this" {
  name = "${var.environment}-ci-profile"
  role = "${aws_iam_role.this.name}"
}

resource "aws_iam_role" "this" {
  name = "${var.environment}-ci-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "main_policy" {
  name        = "${var.environment}-ci-policy"
  description = "Main Ci Policy"
  policy      = "${data.template_file.main_iam_policy.rendered}"
}

resource "aws_iam_role_policy_attachment" "mgd_pol_1" {
  role       = "${aws_iam_role.this.id}"
  policy_arn = "${aws_iam_policy.main_policy.arn}"
}

# -- Templates
data "template_file" "main_iam_policy" {
  template = "${file("${path.module}/policy/main_iam_policy.json")}"

  vars {
    account_id  = "${local.account_id}"
    region      = "${var.region}"
    environment = "${var.environment}"
    prefix      = "${var.prefix}"
  }
}

