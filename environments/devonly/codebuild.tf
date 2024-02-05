#########################################
#   CodeBuild
#########################################
resource "aws_iam_role" "codebuild_role" {
    path = "/"
    name = "${var.env}-${var.pj_name}-codebuild-role"
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
    policy = <<EOP
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GrantCodeCommitPermission",
            "Effect": "Allow",
            "Action": "codecommit:*",
            "Resource": "${aws_codecommit_repository.codecommit_repository.arn}"
        },
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
            "Sid": "GrantPermissionCodeBuild",
            "Effect": "Allow",
            "Action": "codebuild:*",
            "Resource": [
                "${aws_codebuild_project.codebuild_project.arn}"
            ]
        },
        {
            "Sid": "GrantPermissionLogs",
            "Effect": "Allow",
            "Action": "logs:*",
            "Resource": "*"
        }
    ]
}
EOP
}

resource "aws_codebuild_project" "codebuild_project" {
    name = "${var.env}-${var.pj_name}-codebuild-project"
    service_role = aws_iam_role.codebuild_role.arn

    source {
      type = "CODECOMMIT"
      location = aws_codecommit_repository.codecommit_repository.clone_url_http
      git_clone_depth = 1
    }
    source_version = "refs/heads/${var.dev_branch_name}"

    environment {
      compute_type = "BUILD_GENERAL1_SMALL"
      image = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
      type = "LINUX_CONTAINER"
      image_pull_credentials_type = "CODEBUILD"
      privileged_mode = true
    }

    artifacts {
      type = "NO_ARTIFACTS"
    }
  
}