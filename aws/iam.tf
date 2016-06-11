resource "aws_iam_instance_profile" "basic" {
    name = "${var.stack_name}-basic"
    roles = ["${aws_iam_role.role.name}"]
}

resource "aws_iam_role" "role" {
  name               = "${var.stack_name}_basic_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [ {
    "Action": "sts:AssumeRole",
    "Effect": "Allow",
    "Principal": {
      "Service": "ec2.amazonaws.com"
    }
  } ]
}
EOF
}

resource "aws_iam_role_policy" "basic" {
  name               = "${var.stack_name}_host"
  role               = "${aws_iam_role.role.id}"
  policy             = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*",
        "ec2:*",
        "elasticloadbalancing:*",
        "cloudwatch:*",
        "autoscaling:*",
        "ecr:*",
        "route53domains:*",
        "iam:GenerateCredentialReport",
        "iam:Get*",
        "iam:List*",
        "iam:DeleteSSHPublicKey",
        "iam:GetSSHPublicKey",
        "iam:ListSSHPublicKeys"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Deny",
      "Action": [
        "s3:DeleteObject"
      ],
      "Resource": "*"
    }
  ]
}

EOF
}

