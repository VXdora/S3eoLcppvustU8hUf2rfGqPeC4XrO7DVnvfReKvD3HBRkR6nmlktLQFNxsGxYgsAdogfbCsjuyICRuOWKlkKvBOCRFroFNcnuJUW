#########################################
#   KMS
#########################################
resource "aws_kms_key" "kms_key" {
    policy = <<EOK
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${var.prd_account_id}:root"
                ]
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${var.dev_account_id}:root",
                    "${aws_iam_role.codepipeline_role.arn}"
                ]
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        }
    ]
}
EOK
}

resource "aws_kms_alias" "kms_alias" {
    name = "alias/${var.prd_env}-${var.pj_name}-key"
    target_key_id = aws_kms_key.kms_key.key_id
  
}
