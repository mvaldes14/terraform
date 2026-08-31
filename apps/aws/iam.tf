data "aws_caller_identity" "current" {}

locals {
  trusted_principals = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]

  external_ids = {
    terraform = "3b49c2d8-e6f0-4ddb-9a89-6c7f67358519"
    packer    = "7151d23d-1c49-40b5-9e36-7df113fcc6f7"
  }

  managed_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/terraform-assume-role",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/packer-build-role",
  ]
}

data "aws_iam_policy_document" "assume_role" {
  for_each = local.external_ids

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = local.trusted_principals
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [each.value]
    }
  }
}

resource "aws_iam_role" "terraform" {
  name                 = "terraform-assume-role"
  description          = "Assumed by the TFC 'aws' workspace and Atlantis"
  max_session_duration = 3600
  assume_role_policy   = data.aws_iam_policy_document.assume_role["terraform"].json
}

data "aws_iam_policy_document" "terraform" {
  statement {
    sid       = "KMS"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "kms:CreateKey",
      "kms:DescribeKey",
      "kms:ListAliases",
      "kms:ListResourceTags",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:EnableKeyRotation",
      "kms:DisableKeyRotation",
      "kms:GetKeyRotationStatus",
      "kms:GetKeyPolicy",
      "kms:PutKeyPolicy",
    ]
  }

  statement {
    sid       = "S3"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
      "s3:GetBucket*",
      "s3:PutBucket*",
      "s3:DeleteBucketPolicy",
      "s3:GetEncryptionConfiguration",
      "s3:PutEncryptionConfiguration",
      "s3:GetAccountPublicAccessBlock",
    ]
  }

  statement {
    sid       = "ReadAMIs"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ec2:DescribeImages",
      "ec2:DescribeSnapshots",
      "ec2:DescribeRegions",
    ]
  }

  statement {
    sid       = "SelfManageRoles"
    effect    = "Allow"
    resources = local.managed_role_arns
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:UpdateAssumeRolePolicy",
      "iam:UpdateRole",
      "iam:TagRole",
      "iam:UntagRole",
    ]
  }
}

resource "aws_iam_role_policy" "terraform" {
  name   = "terraform-workspace"
  role   = aws_iam_role.terraform.id
  policy = data.aws_iam_policy_document.terraform.json
}

resource "aws_iam_role" "packer" {
  name                 = "packer-build-role"
  description          = "Assumed by Packer to bake AMIs"
  max_session_duration = 3600
  assume_role_policy   = data.aws_iam_policy_document.assume_role["packer"].json
}

data "aws_iam_policy_document" "packer" {
  statement {
    sid       = "PackerBuild"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ec2:RunInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInstanceTypes",
      "ec2:ModifyInstanceAttribute",
      "ec2:GetPasswordData",
      "ec2:CreateKeyPair",
      "ec2:DeleteKeyPair",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:DescribeSecurityGroups",
      "ec2:CreateImage",
      "ec2:RegisterImage",
      "ec2:DeregisterImage",
      "ec2:CopyImage",
      "ec2:DescribeImages",
      "ec2:DescribeImageAttribute",
      "ec2:ModifyImageAttribute",
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot",
      "ec2:DescribeSnapshots",
      "ec2:ModifySnapshotAttribute",
      "ec2:CreateVolume",
      "ec2:DeleteVolume",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:DescribeVolumes",
      "ec2:CreateTags",
      "ec2:DescribeTags",
      "ec2:DescribeRegions",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "ec2:DescribeAvailabilityZones",
    ]
  }
}

resource "aws_iam_role_policy" "packer" {
  name   = "packer-build"
  role   = aws_iam_role.packer.id
  policy = data.aws_iam_policy_document.packer.json
}
