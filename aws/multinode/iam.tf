resource "aws_iam_role" "master" {
  name = "${cluster_prefix}-master"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "ec2:DetachVolume",
        "ec2:AttachVolume",
        "ec2:AuthorizeSecurityGroupIngress",
        "elasticloadbalancing:CreateLoadBalancer",
        "ec2:CreateTags",
        "elasticloadbalancing:ConfigureHealthCheck",
        "ec2:CreateVolume",
        "elasticloadbalancing:CreateLoadBalancerListeners",
        "ec2:RevokeSecurityGroupIngress",
        "elasticloadbalancing:DeleteLoadBalancer",
        "ec2:DeleteVolume",
        "ec2:DeleteSecurityGroup",
        "elasticloadbalancing:DeleteLoadBalancerListeners",
        "elasticloadbalancing:ModifyLoadBalancerAttributes",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer"
      ],
      "Resource": [
        "arn:aws:ec2:*:*:instance/*",
        "arn:aws:ec2:*:*:volume/*",
        "arn:aws:ec2:*:*:security-group/*",
        "arn:aws:elasticloadbalancing:*:*:loadbalancer/*"
      ]
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:DescribeLoadBalancerAttributes",
        "elasticloadbalancing:DescribeLoadBalancers",
        "ec2:DescribeInstances",
        "elasticloadbalancing:DescribeTags",
        "ec2:CreateSecurityGroup",
        "ec2:DescribeVolumes",
        "ec2:DescribeSubnets",
        "ec2:DescribeRouteTables",
        "ec2:DescribeSecurityGroups"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "node" {
  name = "${cluster_prefix}-node"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": "ec2:DescribeInstances",
      "Resource": "*"
    }
  ]
}
EOF
}
