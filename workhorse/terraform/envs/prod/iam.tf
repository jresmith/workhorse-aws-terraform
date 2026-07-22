resource "aws_iam_policy" "alb_controller" {
  name = "${var.cluster_name}-alb-controller-policy"

  policy = file(
    "${path.module}/../../policies/aws-load-balancer-controller.json"
  )
}

resource "aws_iam_role_policy_attachment" "alb_controller_policy_attach" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_controller.arn
}

resource "aws_iam_role" "alb_controller" {
  name = "${var.cluster_name}-alb-controller"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "pods.eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

resource "aws_eks_pod_identity_association" "alb_controller" {
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"

  role_arn = aws_iam_role.alb_controller.arn

  depends_on = [
    aws_iam_role_policy_attachment.alb_controller_policy_attach
  ]
}

resource "aws_iam_policy" "external_dns" {
  name = "${var.cluster_name}-externaldns"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "route53:ChangeResourceRecordSets"
        ]

        Resource = [
          "arn:aws:route53:::hostedzone/Z04740503B1A4DFFP02PZ" # jresmith.com
        ]
      },

      {
        Effect = "Allow"

        Action = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResource"
        ]

        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_role" "external_dns" {
  name = "${var.cluster_name}-external-dns-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "pods.eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "external_dns" {
  role       = aws_iam_role.external_dns.name
  policy_arn = aws_iam_policy.external_dns.arn
}

resource "aws_eks_pod_identity_association" "external_dns" {
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = "external-dns"

  role_arn = aws_iam_role.external_dns.arn
}

resource "aws_iam_role" "ebs_csi_driver" {
  name = "${var.cluster_name}-amazon-eks-ebs-csi-driver-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver" {
  role       = aws_iam_role.ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_eks_pod_identity_association" "ebs_csi" {
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa"

  role_arn = aws_iam_role.ebs_csi_driver.arn
}

resource "aws_iam_role" "yace" {
  name = "${var.cluster_name}-yace"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "pods.eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "yace" {
  name = "${var.cluster_name}-yace"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:ListAccountAliases"
        ]
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = [
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics"
        ]
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = [
          "tag:GetResources",
          "tag:GetTagKeys",
          "tag:GetTagValues"
        ]
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeVolumes",
          "ec2:DescribeTags"
        ]
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeTags",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeListeners"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "yace" {
  role       = aws_iam_role.yace.name
  policy_arn = aws_iam_policy.yace.arn
}

resource "aws_eks_pod_identity_association" "yace" {
  cluster_name    = module.eks.cluster_name
  namespace       = "monitoring"
  service_account = "yace"

  role_arn = aws_iam_role.yace.arn
}

resource "aws_iam_policy" "alloy_cloudwatch_logs" {
  name = "${var.cluster_name}-alloy-cloudwatch-logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents",
          "logs:FilterLogEvents",
          "logs:GetLogGroupFields",
          "logs:StartQuery",
          "logs:GetQueryResults"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "alloy" {
  name = "${var.cluster_name}-alloy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "alloy_cloudwatch_logs" {
  role       = aws_iam_role.alloy.name
  policy_arn = aws_iam_policy.alloy_cloudwatch_logs.arn
}

resource "aws_eks_pod_identity_association" "alloy" {
  cluster_name    = module.eks.cluster_name
  namespace       = "monitoring"
  service_account = "alloy"

  role_arn = aws_iam_role.alloy.arn
}

resource "aws_iam_role" "cloudtrail" {
  name = "workhorse-prod-cloudtrail"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}