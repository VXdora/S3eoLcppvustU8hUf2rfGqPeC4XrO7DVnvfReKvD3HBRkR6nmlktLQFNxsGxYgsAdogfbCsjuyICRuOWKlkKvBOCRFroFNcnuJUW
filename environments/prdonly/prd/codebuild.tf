#########################################
#   CodeBuild
#########################################
resource "aws_iam_role" "codebuild_role" {
    path = "/"
    name = "${var.prd_env}-${var.pj_name}-codebuild-role"
    assume_role_policy = <<EOR
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CodeBuildAssumeRole",
            "Effect": "Allow",
            "Principal": {
                "Service": "codebuild.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOR
}

resource "aws_iam_role_policy" "codebuild_policy" {
    role = aws_iam_role.codebuild_role.name
    name = "${var.prd_env}-${var.pj_name}-codebuild-policy"
    policy = <<EOP
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GrantPermissionS3",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "${aws_s3_bucket.s3_artifact_output_bucket.arn}",
                "${aws_s3_bucket.s3_artifact_output_bucket.arn}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "kms:DescribeKey",
                "kms:GenerateDataKey",
                "kms:Encrypt",
                "kms:ReEncrypt*",
                "kms:Decrypt"
            ],
            "Resource": [
                "${aws_kms_key.kms_key.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "logs:*",
            "Resource": "*"
        }
    ]
}
EOP
}

resource "aws_codebuild_project" "codebuild_project" {
    name = "${var.prd_env}-${var.pj_name}-codebuild-project"
    service_role = aws_iam_role.codebuild_role.arn
    encryption_key = aws_kms_key.kms_key.key_id

    source {
      type = "CODEPIPELINE"
      # location = aws_codecommit_repository.codecommit_repository.clone_url_http
      git_clone_depth = 1
    }
    # source_version = "refs/heads/${var.prd_branch_name}"

    environment {
      compute_type = "BUILD_GENERAL1_SMALL"
      image = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
      type = "LINUX_CONTAINER"
      image_pull_credentials_type = "CODEBUILD"
      privileged_mode = true
    }

    artifacts {
      type = "CODEPIPELINE"
    }
  
}