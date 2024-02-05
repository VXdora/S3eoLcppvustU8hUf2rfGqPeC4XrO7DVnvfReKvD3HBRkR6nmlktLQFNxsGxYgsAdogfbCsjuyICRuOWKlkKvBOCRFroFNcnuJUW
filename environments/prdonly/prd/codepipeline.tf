#########################################
#   CodePipeline
#########################################
resource "aws_iam_role" "codepipeline_role" {
    path = "/"
    name = "${var.prd_env}-${var.pj_name}-codepipeline-role"
    assume_role_policy = <<EOR
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CodePipelineAssumeRole",
            "Effect": "Allow",
            "Principal": {
                "Service": "codepipeline.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOR
}

resource "aws_iam_role_policy" "codepipeline_role_policy" {
  role = aws_iam_role.codepipeline_role.name
  policy = <<EOP
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "GrantPermissionDevAccount",
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "arn:aws:iam::${var.dev_account_id}:role/*"
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
    }
  ]
}
EOP
}

resource "aws_codepipeline" "codepipeline" {
    name = "${var.prd_env}-${var.pj_name}-codepipeline"
    role_arn = aws_iam_role.codepipeline_role.arn

    artifact_store {
      location = aws_s3_bucket.s3_artifact_output_bucket.id
      type = "S3"
      encryption_key {
        id = "${aws_kms_key.kms_key.arn}"
        type = "KMS"
      }
    }

    stage {
      name = "Source"
      action {
        name = "Source"
        category = "Source"
        owner = "AWS"
        provider = "CodeCommit"
        version = "1"
        output_artifacts = ["SourceArtifact"]

        configuration = {
          RepositoryName = var.codecommit_repository_name
          BranchName = var.prd_branch_name
          PollForSourceChanges = "false"
        }
        role_arn = var.codecommit_role_for_prd_arn
      }
    }

    stage {
      name = "Build"

      action {
        name = "Build"
        category = "Build"
        owner = "AWS"
        provider = "CodeBuild"
        version = "1"
        input_artifacts = ["SourceArtifact"]
        output_artifacts = ["BuildArtifact"]

        configuration = {
          ProjectName = aws_codebuild_project.codebuild_project.name
          BatchEnabled = "false"
          CombineArtifacts = "false"
        }
      }
    }
}


#########################################
#   EventBridge
#########################################
# resource "aws_iam_role" "eventbridge_to_codepipeline_role" {
#   name = "${var.prd_env}-${var.pj_name}-eventbridge-to-codepipeline-role"
#   assume_role_policy = <<EORP
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "AssumeRole",
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "events.amazonaws.com"
#             },
#             "Action": "sts:AssumeRole"
#         }
#     ]
# }
# EORP
#     inline_policy {
#       name = "codepipeline"
#       policy = <<EOPA
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "GrantPermissionCodepipeline",
#             "Effect": "Allow",
#             "Action": "codepipeline:StartPipelineExecution",
#             "Resource": "${aws_codepipeline.codepipeline.arn}"
#         }
#     ]
# }
# EOPA
#     }
# }
# 
# resource "aws_cloudwatch_event_rule" "codepipeline_event_rule" {
#   name = "${var.prd_env}-${var.pj_name}-codepipeline-event-rule"
#   event_pattern = <<EOP
# {
#   "source": ["aws.codecommit"],
#   "detail-type": ["CodeCommit Repository State Change"],
#   "resources": ["${aws_codecommit_repository.codecommit_repository.arn}"],
#   "detail": {
#     "event": ["referenceCreated", "referenceUpdated"],
#     "referenceType": ["branch"],
#     "referenceName": ["${var.prd_branch_name}"]
#   }
# }
# EOP
# }
# 
# resource "aws_cloudwatch_event_target" "codepipeline_event_target" {
#     rule = aws_cloudwatch_event_rule.codepipeline_event_rule.name
#     arn = aws_codepipeline.codepipeline.arn
#     role_arn = aws_iam_role.eventbridge_to_codepipeline_role.arn
# }