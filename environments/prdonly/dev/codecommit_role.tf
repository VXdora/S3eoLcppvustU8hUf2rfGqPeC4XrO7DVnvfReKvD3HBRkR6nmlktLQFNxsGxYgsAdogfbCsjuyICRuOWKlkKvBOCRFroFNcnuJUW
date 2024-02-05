#########################################
#   CodeCommitRole
#########################################
resource "aws_iam_role" "codecommit_role_for_prd" {
  name = "${var.dev_env}-${var.pj_name}-codecommit-role-for-prd"
  assume_role_policy = <<EOR
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${var.dev_account_id}:root",
                    "arn:aws:iam::${var.prd_account_id}:root"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOR
}

resource "aws_iam_role_policy" "codecommit_role_policy_for_prd" {
  name = "${var.dev_env}-${var.pj_name}-codecommit-role-policy-for-prd"
  role = aws_iam_role.codecommit_role_for_prd.name
  policy = <<EOP
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "${var.s3_artifact_output_bucket_arn}",
                "${var.s3_artifact_output_bucket_arn}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "kms:*",
            "Resource": [
                "${var.kms_key_arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "codecommit:*",
            "Resource": [
                "arn:aws:codecommit:ap-northeast-1:${var.dev_account_id}:${var.codecommit_repository_name}"
            ]
        }
    ]
}
EOP
}
